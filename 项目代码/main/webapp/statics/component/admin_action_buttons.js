(function () {
    var STYLE_ID = "bbs-admin-action-button-style";
    var pendingApply = false;

    function ensureStyle() {
        if (document.getElementById(STYLE_ID)) {
            return;
        }
        var style = document.createElement("style");
        style.id = STYLE_ID;
        style.textContent = ""
            + ".bbs-action-btn,.layui-table .bbs-action-btn,.layui-table-view .bbs-action-btn{display:inline-block!important;height:22px!important;line-height:20px!important;padding:0 7px!important;margin:0 2px!important;border-radius:3px!important;font-size:12px!important;text-align:center!important;white-space:nowrap!important;vertical-align:middle!important;box-sizing:border-box!important;text-decoration:none!important;transition:background-color .15s ease,border-color .15s ease,color .15s ease!important;}"
            + ".bbs-danger-action,.bbs-danger-action:link,.bbs-danger-action:visited,.layui-table .bbs-danger-action,.layui-table-view .bbs-danger-action{background-color:#fff!important;border:1px solid #d9d9d9!important;color:#d93025!important;}"
            + ".bbs-danger-action:hover,.bbs-danger-action:active,.bbs-danger-action:focus,.layui-table .bbs-danger-action:hover,.layui-table-view .bbs-danger-action:hover{background-color:#d93025!important;border-color:#d93025!important;color:#fff!important;}"
            + ".bbs-danger-action-disabled,.bbs-danger-action-disabled:link,.bbs-danger-action-disabled:visited,.bbs-danger-action-disabled:hover,.bbs-danger-action-disabled:active,.bbs-danger-action-disabled:focus,.layui-table .bbs-danger-action-disabled,.layui-table-view .bbs-danger-action-disabled{background-color:#fff!important;border:1px solid #d9d9d9!important;color:#999!important;cursor:not-allowed!important;}"
            + ".bbs-neutral-action,.bbs-neutral-action:link,.bbs-neutral-action:visited,.layui-table .bbs-neutral-action,.layui-table-view .bbs-neutral-action{background-color:#fff!important;border:1px solid #d9d9d9!important;color:#222!important;}"
            + ".bbs-neutral-action:hover,.bbs-neutral-action:active,.bbs-neutral-action:focus,.layui-table .bbs-neutral-action:hover,.layui-table-view .bbs-neutral-action:hover{background-color:#d93025!important;border-color:#d93025!important;color:#fff!important;}"
            + ".bbs-status-action,.bbs-status-action:link,.bbs-status-action:visited,.layui-table .bbs-status-action,.layui-table-view .bbs-status-action{background-color:#fff!important;border:1px solid #d9d9d9!important;}"
            + ".bbs-status-action:hover,.bbs-status-action:active,.bbs-status-action:focus,.layui-table .bbs-status-action:hover,.layui-table-view .bbs-status-action:hover{background-color:#fff!important;border-color:#d9d9d9!important;color:#222!important;}";
        document.head.appendChild(style);
    }

    function applyBase(button) {
        button.style.setProperty("display", "inline-block", "important");
        button.style.setProperty("height", "22px", "important");
        button.style.setProperty("line-height", "20px", "important");
        button.style.setProperty("padding", "0 7px", "important");
        button.style.setProperty("margin", "0 2px", "important");
        button.style.setProperty("border-radius", "3px", "important");
        button.style.setProperty("font-size", "12px", "important");
        button.style.setProperty("text-align", "center", "important");
        button.style.setProperty("white-space", "nowrap", "important");
        button.style.setProperty("vertical-align", "middle", "important");
        button.style.setProperty("box-sizing", "border-box", "important");
        button.style.setProperty("text-decoration", "none", "important");
    }

    function applyDangerDefault(button) {
        applyBase(button);
        button.style.setProperty("background-color", "#fff", "important");
        button.style.setProperty("border", "1px solid #d9d9d9", "important");
        button.style.setProperty("color", "#d93025", "important");
        button.style.setProperty("cursor", "pointer", "important");
    }

    function applyDangerHover(button) {
        applyBase(button);
        button.style.setProperty("background-color", "#d93025", "important");
        button.style.setProperty("border", "1px solid #d93025", "important");
        button.style.setProperty("color", "#fff", "important");
    }

    function applyNeutralDefault(button) {
        applyBase(button);
        button.style.setProperty("background-color", "#fff", "important");
        button.style.setProperty("border", "1px solid #d9d9d9", "important");
        button.style.setProperty("color", "#222", "important");
        button.style.setProperty("cursor", "pointer", "important");
    }

    function applyStatusDefault(button) {
        var color = button.getAttribute("data-default-color") || "#222";
        applyBase(button);
        button.style.setProperty("background-color", "#fff", "important");
        button.style.setProperty("border", "1px solid #d9d9d9", "important");
        button.style.setProperty("color", color, "important");
        button.style.setProperty("cursor", "pointer", "important");
    }

    function applyStatusHover(button) {
        applyBase(button);
        button.style.setProperty("background-color", "#fff", "important");
        button.style.setProperty("border", "1px solid #d9d9d9", "important");
        button.style.setProperty("color", "#222", "important");
    }

    function applyDisabled(button) {
        applyBase(button);
        button.style.setProperty("background-color", "#fff", "important");
        button.style.setProperty("border", "1px solid #d9d9d9", "important");
        button.style.setProperty("color", "#999", "important");
        button.style.setProperty("cursor", "not-allowed", "important");
    }

    function applyAll() {
        pendingApply = false;
        ensureStyle();
        normalizeLegacyButtons();
        document.querySelectorAll(".bbs-danger-action").forEach(applyDangerDefault);
        document.querySelectorAll(".bbs-neutral-action").forEach(applyNeutralDefault);
        document.querySelectorAll(".bbs-danger-action-disabled").forEach(applyDisabled);
        document.querySelectorAll(".bbs-status-action").forEach(function (button) {
            var defaultText = button.getAttribute("data-default-text");
            if (defaultText && !button.matches(":hover")) {
                button.textContent = defaultText;
                applyStatusDefault(button);
            }
        });
    }

    function normalizeLegacyButtons() {
        var path = window.location.pathname;
        var targetPage = path.indexOf("/user-manage") !== -1
            || path.indexOf("/posts-lists") !== -1
            || path.indexOf("/posts_details-lists") !== -1
            || path.indexOf("/posts_reply") !== -1
            || path.indexOf("/posts_report-lists") !== -1;
        if (!targetPage) {
            return;
        }
        document.querySelectorAll(".layui-table-cell a[lay-event]").forEach(function (button) {
            var eventName = button.getAttribute("lay-event");
            if (button.classList.contains("layui-btn-disabled")) {
                button.classList.add("bbs-action-btn", "bbs-danger-action-disabled");
                return;
            }
            if (button.classList.contains("bbs-status-action")) {
                button.classList.add("bbs-action-btn");
            } else if (eventName === "removal" || eventName === "look" || eventName === "resetPassword") {
                button.classList.add("bbs-action-btn", "bbs-neutral-action");
            } else if (eventName === "del" || eventName === "dispose" || eventName === "audit" || eventName === "addRole" || eventName === "userStateCut") {
                button.classList.add("bbs-action-btn", "bbs-danger-action");
            }
        });
    }

    function scheduleApplyAll() {
        if (pendingApply) {
            return;
        }
        pendingApply = true;
        setTimeout(applyAll, 0);
    }

    document.addEventListener("mouseover", function (event) {
        var statusButton = event.target.closest && event.target.closest(".bbs-status-action");
        if (statusButton) {
            var statusHoverText = statusButton.getAttribute("data-hover-text");
            if (statusHoverText) {
                statusButton.textContent = statusHoverText;
            }
            applyStatusHover(statusButton);
            return;
        }
        var button = event.target.closest && event.target.closest(".bbs-danger-action, .bbs-neutral-action");
        if (button) {
            var hoverText = button.getAttribute("data-hover-text");
            if (hoverText) {
                button.textContent = hoverText;
            }
            applyDangerHover(button);
        }
    });

    document.addEventListener("mouseout", function (event) {
        var statusButton = event.target.closest && event.target.closest(".bbs-status-action");
        if (statusButton) {
            var statusDefaultText = statusButton.getAttribute("data-default-text");
            if (statusDefaultText) {
                statusButton.textContent = statusDefaultText;
            }
            applyStatusDefault(statusButton);
            return;
        }
        var button = event.target.closest && event.target.closest(".bbs-danger-action, .bbs-neutral-action");
        if (button) {
            var defaultText = button.getAttribute("data-default-text");
            if (defaultText) {
                button.textContent = defaultText;
            }
            if (button.classList.contains("bbs-neutral-action")) {
                applyNeutralDefault(button);
            } else {
                applyDangerDefault(button);
            }
        }
    });

    document.addEventListener("DOMContentLoaded", function () {
        applyAll();
        if (window.MutationObserver) {
            new MutationObserver(function () {
                scheduleApplyAll();
            }).observe(document.body, { childList: true, subtree: true });
        }
    });
    if (document.readyState !== "loading") {
        applyAll();
    }
    window.applyAdminActionButtonStyles = applyAll;
})();
