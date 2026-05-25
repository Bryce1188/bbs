
//通讯服务器
var ws = null;
//登录用户信息
var userInfo = null;
//聊天对象
var tarUser = null;
//主动退出标记，避免退出后 websocket 自动重连干扰登录流程
var isManualLogout = false;

function closeWebsocketForLogout() {
    isManualLogout = true;
    if (ws != null) {
        try {
            ws.onclose = null;
            ws.onerror = null;
            ws.onmessage = null;
            ws.close();
        } catch (e) {
            console.log(e);
        }
        ws = null;
    }
}
function getAppContextPath() {
    var pathname = window.location.pathname || "";
    var first = pathname.split("/")[1];
    if (!first) {
        return "/leek_bbs";
    }
    return "/" + first;
}
var APP_CTX = getAppContextPath();

Vue.component('head_menu_comp', {
    props:['is_login'],
    template: `<header class="bbs-topbar">
        <div class="bbs-topbar-inner">
            <a class="bbs-brand" :href="ctx + '/skipPage/index'">
                <span class="bbs-brand-mark">BBS</span>
                <span class="bbs-brand-name">校园论坛</span>
            </a>
            <nav class="bbs-topnav">
                <a :href="ctx + '/skipPage/index'">首页</a>
                <a :href="ctx + '/skipPage/daodu'">全部帖子</a>
                <a :href="ctx + '/skipPage/ranking_list'">排行</a>
                <template v-if="isUserShow">
                    <div class="bbs-user-menu" @mouseenter="openMenu" @mouseleave="scheduleMenuClose">
                        <div class="bbs-user-access">
                            <a id="d-photo" class="bbs-user-trigger" href="javascript:;" @click.stop="toggleMenu">
                                <img :src="getAvatar()" :alt="displayName">
                                <span>{{displayName}}</span>
                            </a>
                            <a class="bbs-mail-link" :href="ctx + '/skipPage/msg-notification'" title="我的消息">
                                <svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="m3 7 9 6 9-6"></path></svg>
                                <span class="badge" v-if="unreadCount > 0">{{unreadCount > 99 ? '99+' : unreadCount}}</span>
                            </a>
                        </div>
                        <div class="bbs-user-panel" :class="{open:isOpenActive}" @mouseenter="holdMenu" @mouseleave="scheduleMenuClose" data-stopPropagation>
                            <a :href="ctx + '/skipPage/spacecp'" @click="closeMenu">设置</a>
                            <a :href="ctx + '/skipPage/my-post'" @click="closeMenu">我的帖子</a>
                            <a :href="ctx + '/skipPage/my-collect'" @click="closeMenu">我的收藏</a>
                            <a :href="ctx + '/skipPage/spacecp#care'" @click="closeMenu">我的关注</a>
                            <a href="javascript:;" @click="logout">退出登录</a>
                        </div>
                    </div>
                </template>
                <template v-else>
                    <a href="javascript:;" class="bbs-auth-link" @click="loginBtn">登录</a>
                    <a href="javascript:;" class="bbs-auth-link" @click="registerBtn">立即注册</a>
                </template>
                <a class="bbs-publish-btn" href="javascript:;" @click.prevent="handlePublishEntry">发布帖子</a>
            </nav>
        </div>
        <a id="c-photo" style="display:none;"></a>
        <audio id="audioPlay" :src="ctx + '/statics/mp3/QQ_xiaoxi.mp3'" hidden></audio>
    </header>`,
    data:function () {
        return {
            isOpenActive:false,
            isLoginShow:this.is_login,
            isUserShow:false,
            ctx:APP_CTX,
            currentUser:null,
            unreadCount:0,
            closeTimer:null
        }

    },
    computed:{
        displayName:function () {
            if (!this.currentUser) {
                return "用户";
            }
            return this.currentUser.another_name || this.currentUser.username || "用户";
        }
    },
    methods: {
        syncCurrentUser:function () {
            try {
                var cache = localStorage.getItem("initUser");
                if (cache) {
                    var parsed = JSON.parse(cache);
                    if (parsed && parsed.userInfo) {
                        this.currentUser = parsed.userInfo;
                        userInfo = parsed.userInfo;
                        this.isUserShow = true;
                        this.isLoginShow = false;
                        this.refreshUnreadCount();
                        return;
                    }
                }
            } catch (e) {
                console.log(e);
            }
            this.currentUser = null;
            this.isUserShow = false;
            this.isLoginShow = true;
            this.unreadCount = 0;
        },
        getAvatar:function () {
            if (!this.currentUser || !this.currentUser.picture) {
                return this.ctx + "/statics/images/head_portrait/comiis_nologin.jpg";
            }
            return this.ctx + "/" + this.currentUser.picture;
        },
        refreshUnreadCount:function () {
            if (!this.currentUser || !this.currentUser.id) {
                this.unreadCount = 0;
                return;
            }
            var that = this;
            axios.post(APP_CTX + "/bbs/privateMsg/unreadCount",{userId:this.currentUser.id})
                .then(function (response) {
                    var data = response.data || {};
                    that.unreadCount = data.count || 0;
                })
                .catch(function () {
                    that.unreadCount = 0;
                });
        },
        toggleMenu(){
            this.holdMenu();
            this.isOpenActive = !this.isOpenActive;
        },
        openMenu:function () {
            this.holdMenu();
            this.isOpenActive = true;
        },
        holdMenu:function () {
            if (this.closeTimer != null) {
                clearTimeout(this.closeTimer);
                this.closeTimer = null;
            }
        },
        scheduleMenuClose:function () {
            var that = this;
            this.holdMenu();
            this.closeTimer = setTimeout(function () {
                that.isOpenActive = false;
            }, 260);
        },
        closeMenu:function () {
            this.holdMenu();
            this.isOpenActive = false;
        },
        registerBtn(){
           layui.register();
        },
        loginBtn(){
            layui.login();

        },
        loginSubmit(){
            this.syncCurrentUser();
            this.isLoginShow = false;
            this.isUserShow = true;
        },
        handlePublishEntry(){
            if (userInfo != null){
                window.location.href = this.ctx + "/skipPage/sendArticle";
            }else {
                layui.login();
            }
        },
        logout(){
            this.closeMenu();
            localStorage.removeItem("initUser");
            closeWebsocketForLogout();
            window.location.reload();
        },
        handleDocumentClick:function () {
            this.closeMenu();
        }
    },
    mounted:function () {
        this.syncCurrentUser();
        var that = this;
        this._docClickHandler = function () {
            that.handleDocumentClick();
        };
        document.addEventListener("click", this._docClickHandler);
        this._refreshUnreadTimer = setInterval(function () {
            that.syncCurrentUser();
            that.refreshUnreadCount();
        }, 3000);
    },
    beforeDestroy:function () {
        if (this.closeTimer != null) {
            clearTimeout(this.closeTimer);
        }
        if (this._docClickHandler) {
            document.removeEventListener("click", this._docClickHandler);
        }
        if (this._refreshUnreadTimer) {
            clearInterval(this._refreshUnreadTimer);
        }
    }
});

var head_menu = new Vue({
    el: '#hmc',
    data:function () {
        return {
            isLoginShow:true
        }
    },
    methods: {
        loginSuccess(){
            if (this.$refs && this.$refs.fo && typeof this.$refs.fo.loginSubmit === "function") {
                this.$refs.fo.loginSubmit();
            }
        }
    }

});


//阻止点击事件传递
$(document).on("click", "[data-stopPropagation]", function(e) {
    e.stopPropagation();
});
$(document).on("click", function() {
    if (head_menu && head_menu.$refs && head_menu.$refs.fo && typeof head_menu.$refs.fo.closeMenu === "function") {
        head_menu.$refs.fo.closeMenu();
    }
});

layui.define(['layer','form','util'],function (exports) {

    var layer = layui.layer,
        form = layui.form,
        util = layui.util;

    getUserInformation('');

    var registerLayerOpen = function () {
        layer.open({
            type: 1,
            id: 'Lay-register',
            skin: 'bbs-auth-layer',
            title: '用户注册',
            content: `<div class="bbs-auth-modal bbs-auth-modal-register">
            <form class="layui-form bbs-auth-form" lay-filter="registerForm">
                <div class="bbs-auth-field">
                    <label class="layui-form-label">昵称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="another_name" lay-verify="required" autocomplete="off" placeholder="请输入昵称" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="username" lay-verify="required" autocomplete="off" placeholder="请输入用户名" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field">
                    <label class="layui-form-label">密码</label>
                    <div class="layui-input-inline">
                        <input type="password" name="password" lay-verify="required|password" autocomplete="off" placeholder="请输入密码" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field">
                    <label class="layui-form-label">确认密码</label>
                    <div class="layui-input-inline">
                        <input type="password" name="pwd" lay-verify="required" autocomplete="off" placeholder="请再次输入密码" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field">
                    <label class="layui-form-label">邮箱</label>
                    <div class="layui-input-inline">
                        <input type="email" name="email" lay-verify="required|email" autocomplete="off" placeholder="请输入邮箱" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field bbs-auth-captcha-row">
                    <label class="layui-form-label">验证码</label>
                    <div class="layui-input-inline bbs-auth-captcha-input">
                        <input type="text" name="imgCode" lay-verify="required" autocomplete="off" placeholder="输入验证码" class="layui-input">
                    </div>
                    <div class="layui-input-inline bbs-auth-captcha-img-wrap">
                        <img id="captchaPic" class="captchaPic" src="${APP_CTX}/bbs/user/verifyCode" alt="验证码">
                    </div>
                </div>
                <div class="bbs-auth-helper-row">
                    <a id="toLogin" href="javascript:;">已有账号，去登录</a>
                </div>
                <div class="bbs-auth-error-row">
                    <span id="errorRes"></span>
                </div>
                <div class="bbs-auth-actions-row bbs-auth-actions-row-double">
                    <button type="submit" class="layui-btn btn-bg" lay-submit="" lay-filter="registerBtn">注册</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </form>
            </div>`,
            anim: 2,
            fixed: false,
            maxmin: false,
            resize: false,
            scrollbar: false,
            area: ['560px', '640px']
        });

    };
    exports('register', registerLayerOpen);
    window.showRegisterLayer = registerLayerOpen;
    //自定义验证规则
    form.verify({
        password: [
            /^[\S]{6,16}$/
            ,'密码必须6到16位，且不能出现空格'
        ]
        ,phone:[/^1[3|4|5|7|8]\d{9}$/,'手机号格式不对！']
        ,email:[/^[a-z0-9._%-]+@([a-z0-9-]+\.)+[a-z]{2,4}$|^1[3|4|5|7|8]\d{9}$/,'邮箱格式不对']
    });

    $(document).on("click","#toLogin",function () {
        layer.closeAll();
        layui.login();
    });

    function refreshCaptchaImage($scope) {
        var ts = new Date().getTime();
        var $imgs = $scope ? $scope.find("img.captchaPic") : $("img.captchaPic:visible");
        if ($imgs.length === 0) {
            $imgs = $("img.captchaPic");
        }
        $imgs.each(function () {
            $(this).attr('src', APP_CTX + '/bbs/user/verifyCode?img=' + ts + '&r=' + Math.random());
        });
    }

    function clearAndFocusCaptchaInput($scope) {
        var $input = $scope ? $scope.find("input[name='imgCode']") : $("input[name='imgCode']:visible").first();
        if ($input.length > 0) {
            $input.val('');
            $input.focus();
        }
    }

    //监听注册提交
    form.on('submit(registerBtn)', function(data){
        var user = data.field;
        var $form = $(data.form);
        if (data.field.another_name.length > 13) {
            layer.msg('昵称太长了', {icon: 5,time: 2000});
            return false;
        }
        if (data.field.password != data.field.pwd) {
            layer.msg('两次密码不一致', {icon: 5,time: 2000});
        }else {
            axios.post(APP_CTX + "/bbs/user/register",user)
                .then(result => {
                    var resdata = result.data;
                    if (resdata.code == "500020") {     //用户注册成功
                        layer.msg('<img src="' + APP_CTX + '/statics/yu-ui/images/ui-success.png">&emsp;用户注册成功', {
                            time: 2000 //2秒关闭（如果不配置，默认是3秒）
                        }, function(){
                            layer.closeAll();
                            layui.login();
                        });
                    }else if (resdata.code == "500023") {   //验证码错误
                        $("#errorRes").text(resdata.msg);
                        refreshCaptchaImage($form);
                        clearAndFocusCaptchaInput($form);
                    }else if (resdata.code == "300022"){    //用户存在
                        $("#errorRes").text(resdata.msg);
                    } else {   //用户注册失败
                        layer.msg('<img src="' + APP_CTX + '/statics/yu-ui/images/ui-error.png">&emsp;'+resdata.msg, {
                            time: 3000 //2秒关闭（如果不配置，默认是3秒）
                        });
                    }
                })
                .catch(error => {
                    console.log(error);
                })
        }

        return false;
    });
    //监听登录提交
    form.on('submit(loginBtn)', function(data){
        var $form = $(data.form);
        //ui.success('提示内容',时间,是否有遮蔽层);
        $.ajax({
            type: "post",
            url: APP_CTX + "/bbs/user/login",
            data:{
                "username":data.field.username,
                "password":data.field.password,
                "imgCode":data.field.imgCode
            },
            dataType:"json",
            success: function(result) {
                console.log(result);
                if (result.code == "500020"){
                    getUserInformation(data.field.username);
                    if ($("#remember").prop("checked")){
                        //写入cookie A.wc(名字,值,过期时间);
                        A.wc("username",data.field.username,24*60*60*1000);
                        A.wc("password",data.field.password,24*60*60*1000);
                    }else {
                        A.wc("username",null,0);
                        A.wc("password",null,0);
                    }
                    setTimeout(function () {
                        layer.closeAll();
                    },500);

                }else if (result.code == "500023") {
                    $("#errorRes").text(result.msg);
                    refreshCaptchaImage($form);
                    clearAndFocusCaptchaInput($form);
                }else if (result.code == "500024"){
                    layer.msg(result.msg);
                } else {
                    $("#errorRes").text(result.msg);
                }
            },
            error: function(error){
                console.log(error)
            }
        })
        return false;
    });

    //登录弹窗方法
    var loginLayerOpen = function () {
        layer.open({
            type: 1,
            id: 'Lay-login',
            skin: 'bbs-auth-layer',
            title: '用户登录',
            content: `<div class="bbs-auth-modal bbs-auth-modal-login">
            <form class="layui-form bbs-auth-form" lay-filter="loginForm">
                <div class="bbs-auth-field">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="username" lay-verify="required" autocomplete="off" placeholder="请输入用户名" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field">
                    <label class="layui-form-label">密码</label>
                    <div class="layui-input-inline">
                        <input type="password" name="password" lay-verify="required" autocomplete="off" placeholder="请输入密码" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field bbs-auth-captcha-row">
                    <label class="layui-form-label">验证码</label>
                    <div class="layui-input-inline bbs-auth-captcha-input">
                        <input type="text" name="imgCode" lay-verify="required" autocomplete="off" placeholder="输入验证码" class="layui-input">
                    </div>
                    <div class="layui-input-inline bbs-auth-captcha-img-wrap">
                        <img id="captchaPic" class="captchaPic" src="${APP_CTX}/bbs/user/verifyCode" alt="验证码">
                    </div>
                </div>
                <div class="bbs-auth-switch-row">
                    <div class="bbs-auth-check-wrap">
                        <input id="remember" type="checkbox" name="isRemember" title="记住我" value="1" lay-skin="primary">
                    </div>
                    <a href="javascript:;" id="forgetPassword">忘记密码？</a>
                </div>
                <div class="bbs-auth-error-row">
                    <span id="errorRes"></span>
                </div>
                <div class="bbs-auth-actions-row">
                    <button type="submit" class="layui-btn layui-btn-fluid btn-bg" lay-submit="" lay-filter="loginBtn">登录</button>
                </div>
            </form>
            </div>`,
            anim: 2,
            fixed: false,
            maxmin: false,
            resize: false,
            scrollbar: false,
            area: ['560px', '500px'],
            success: function () {
                setTimeout(() => {
                    refreshCaptchaImage();
                },300);
                form.val('loginForm', {
                    "username": A.rc("username"),
                    "password": A.rc("password"),
                    "isRemember": true
                });
            }
        });
    };
    exports('login', loginLayerOpen);
    window.showLoginLayer = loginLayerOpen;
    //修改密码
    function alterPwd(){
        layer.open({
            type: 1,
            id: 'Lay-pwd',
            skin: 'bbs-auth-layer',
            title: '找回密码',
            content: `<div class="bbs-auth-modal bbs-auth-modal-pwd">
            <form class="layui-form bbs-auth-form" lay-filter="alterPwdForm">
                <div class="bbs-auth-field">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input id="user-name" type="text" name="username" lay-verify="required" autocomplete="off" placeholder="请输入用户名" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field">
                    <label class="layui-form-label">新密码</label>
                    <div class="layui-input-inline">
                        <input type="password" name="password" lay-verify="required" autocomplete="off" placeholder="请输入新密码" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field">
                    <label class="layui-form-label">确认密码</label>
                    <div class="layui-input-inline">
                        <input type="password" id="classPwd" name="pwd" placeholder="再次输入新密码" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="bbs-auth-field bbs-auth-captcha-row">
                    <label class="layui-form-label">邮箱验证码</label>
                    <div class="layui-input-inline bbs-auth-captcha-input">
                        <input type="text" name="emailCode" placeholder="输入邮箱验证码" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                    <div id="sendVerify" class="layui-input-inline bbs-auth-send-wrap">
                        <button id="sendCode" class="btn btn-default btn-primary" type="button">发送验证码</button>
                    </div>
                </div>
                <div class="bbs-auth-error-row">
                    <span id="errorRes"></span>
                </div>
                <div class="bbs-auth-actions-row">
                    <button type="submit" class="layui-btn layui-btn-fluid btn-bg" lay-submit="" lay-filter="alterPwdBtn">提交</button>
                </div>
            </form>
            </div>`,
            anim: 2,
            fixed: false,
            maxmin: false,
            resize: false,
            scrollbar: false,
            area: ['560px', '500px']
        })
    }


    //切换验证码
    $(document).on("click",".captchaPic",function () {
        refreshCaptchaImage($(this).closest("form"));
    });

    $(document).on("click","#forgetPassword",function () {
        layer.closeAll();
        alterPwd();
    });
    $(document).on("click","#sendCode",function () {
        let username = $("#user-name").val();
        if (username != null && username != '') {
            countDown(username);
        }else {
            layer.msg('请先输入用户名', {icon: 5,time: 2000});
        }
        return false;
    });

    //密码修改
    form.on('submit(alterPwdBtn)', function(data){
        if (count > 0) {
            if (data.field.password != data.field.pwd) {
                layer.msg('两次密码不一致', {icon: 5,time: 2000});
                $("#classPwd").focus();
            }else {
                axios.post(APP_CTX + '/bbs/user/alterUserInfo',data.field).then(response => {
                    let resData = response.data;
                    if (resData.code == "500020") {
                        layer.msg(`<img src="${APP_CTX}/statics/yu-ui/images/ui-success.png">&emsp;密码修改成功`, {
                            time: 3000 //2秒关闭（如果不配置，默认是3秒）
                        },function () {
                            layer.closeAll();
                            layui.login();
                        });
                    }else if (resData.code == "0x10001") {
                        ui.error(resData.msg,2000,true);
                    }else {
                        $("#errorRes").text(resData.msg);
                    }
                }).catch(error => {
                    console.log(error);
                });
            }
        }else {
            layer.msg('请先验证邮箱再提交', {icon: 5,time: 2000});
        }
        return false;
    });

    let count = 0;

    //倒计时
    function countDown(username) {
        axios.get(`${APP_CTX}/bbs/user/sendEmail?username=${username}`).then(response => {
            let data = response.data;
            if (data.msg == "success"){
                let endTime = new Date().getTime()+60*1000 //假设为结束日期
                    ,serverTime = new Date().getTime(); //假设为当前服务器时间，这里采用的是本地时间，实际使用一般是取服务端的

                util.countdown(endTime, serverTime, function(date, serverTime, timer){
                    let str =date[3];
                    layui.$(`#sendVerify`).html(`<button class="btn btn-default" disabled>重新发送(${str})</button>`);
                    if (str == 0){
                        layui.$(`#sendVerify`).html(`<button id="sendCode" class="btn btn-default btn-primary">发送验证码</button>`);
                    }
                });
                layer.msg(`<img src="${APP_CTX}/statics/yu-ui/images/ui-success.png">&emsp;验证码发送成功,请到邮箱注意查看!`, {
                    time: 3000 //2秒关闭（如果不配置，默认是3秒）
                });
                count ++;
            }else if (data.code == "500025"){
                $("#errorRes").text(data.msg);
            } else {
                layer.msg(data.msg, {
                    time: 2000
                });
            }
        }).catch(error => {
            console.log(error);
            layer.msg('数据请求出现异常', {
                time: 2000
            });
        })

    }


});
//获取登录用户信息以及创建聊天连接
function getUserInformation(username){
    if (localStorage.getItem("initUser") == null){
        if (username != null && username != ''){
            axios.get(APP_CTX + '/bbs/user/getUserInfo?username='+username)
                .then(function (result) {
                    let data = result.data;
                    if (data != null){
                        //head_menu.loginSuccess();
                        window.localStorage.setItem('initUser', JSON.stringify(data));
                        window.location.reload();
                        let map = JSON.parse(window.localStorage.getItem("initUser"));
                        userInfo = map.userInfo;
                        $("#u-ig").html(`<span>积分:&nbsp;${map.total_integral}</span>&nbsp;<span>用户组:&nbsp;${map.grade.name}</span>`);
                        setTimeout(function () {
                            websocketLinkStart(userInfo);
                        },1000);
                    }
                })
                .catch(function (error){
                    console.log(error);
                })
        }
    }else{
        if (head_menu && typeof head_menu.loginSuccess === "function") {
            head_menu.loginSuccess();
        }
        let map = JSON.parse(window.localStorage.getItem("initUser"));
        userInfo = map.userInfo;
        console.log(map);
        $("#u-ig").html(`<span>积分:&nbsp;${map.total_integral}</span>&nbsp;<span>用户组:&nbsp;${map.grade.name}</span>`);
        websocketLinkStart(userInfo)
    }

}

//封装服务连接方法
function websocketLinkStart(userInfo) {
    if (isManualLogout) {
        return;
    }
    if (!userInfo || !userInfo.id) {
        return;
    }
    if (ws && (ws.readyState === WebSocket.OPEN || ws.readyState === WebSocket.CONNECTING)) {
        return;
    }
    if(WebSocket){
        //ws = new WebSocket("ws://jxz.free.qydev.com:8080/websocket/"+userInfo.id);
        //本地连接
         ws = new WebSocket("ws://localhost:8080" + APP_CTX + "/websocket/"+userInfo.id);
    }else {
        alert("您的浏览器不支持Websocket!");
    }
    //连接建立成功的回调方法
    ws.onopen = function () {
        isManualLogout = false;
        console.log("连接建立成功!");
    };
    //连接发生错误的回调方法
    ws.onerror = function (e) {
        console.error("WebSocket连接发生错误");
    };
    //接收服务器端的消息
    ws.onmessage = function (ev) {
        let data = JSON.parse(ev.data);
        /*if (data.srcUser.userId != userInfo.id){
            data.isOneself = false;
        }*/
        let loginUserId = userInfo.id;
        if ($("#chatSession-W")[0] == null){
            if (data.tarUser.userId == userInfo.id){
                var unreadCount = 1;
                //let privateMsg = JSON.parse(window.localStorage.getItem(`privateMsg-${userInfo.id}`));
                let privateMsg = JSON.parse(window.localStorage.getItem(`msgData`));
                if (privateMsg == null){
                    privateMsg = [];
                }else if (privateMsg.length > 30){
                    privateMsg = [];
                }
                privateMsg.push({
                    srcUser:data.srcUser,
                    tarUser:data.tarUser,
                    img:data.img,
                    time:data.time,
                    content:data.content,
                    status:0
                });
                unreadCount = privateMsg.filter(function (msg) {
                    return msg && msg.status === 0 && msg.tarUser && msg.tarUser.userId == userInfo.id;
                }).length;
                window.localStorage.setItem(`msgData`,JSON.stringify(privateMsg));
                $(".badge").css("display","").text(unreadCount > 99 ? "99+" : unreadCount);
                let player = document.getElementById("audioPlay");
                player.play();
            }
            //console.log("未打开聊天窗口...");
        }else {
            //获取iframe页面的window对象,[0]将JQuery对象转成DOM对象,用DOM对象的contentWindow获取子页面window对象。
            let childWindow = $("#chatSession-W")[0].contentWindow;
            childWindow.sendMessage(data,loginUserId);  //调用子页面中的sendMessage方法。
        }

    };
    // 监听断开连接的方法.
    ws.onclose = function(event) {
        if (isManualLogout) {
            return;
        }
        if (localStorage.getItem("initUser") == null) {
            return;
        }
        if (!userInfo || !userInfo.id) {
            return;
        }
        setTimeout(function () {
            websocketLinkStart(userInfo);
        }, 1500);
    };
}
// 退出系统时, 关闭建立的WebSocket链接
//离开页面,改变用户状态
window.onunload = function() {
    closeWebsocketForLogout();
};

//获取地地址栏文件部分
function getUrlIndexOf(path) {
    let urlPathName = window.location.pathname;
    if (urlPathName.includes(path)){return true};
}

//获取url中的参数
function getUrlParam(name) {
    let reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
    let r = window.location.search.substr(1).match(reg);  //匹配目标参数
    if (r != null) return decodeURI(r[2]); return null; //返回参数值
}
