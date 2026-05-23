package com.lindong.aspect;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Log {//只有被@Log注解的方法才会被AOP切面捕获并记录操作日志

    //执行的操作
    String operation();

}
