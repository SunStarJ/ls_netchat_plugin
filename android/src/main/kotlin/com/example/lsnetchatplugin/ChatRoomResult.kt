package com.example.lsnetchatplugin

object ChatRoomResult {

    val login = 100

    val enterRoom = 103
    val exitRoom = 104
    val receiveMessage = 105


    fun getLogoutErrorMessage(code:Int):String{
        return when(code){
            302->"账号密码错误"
            408->"服务器未响应"
            415->"网络断开"
            416->"请求过于频繁"
            417->"未开启多端登陆"
            1000->"数据库未开启"
            else -> ""
        }
    }
    fun getEnterChatRoomMessage(code:Int):String{
        return when(code){
            414->"参数错误"
            404->"聊天室不存在"
            403->"无权限"
            500->"服务器内部错误"
            13001->"IM主连接状态异常"
            13002->"聊天室状态异常"
            13003->"黑名单用户禁止进入聊天室"
            else -> ""
        }
    }

}