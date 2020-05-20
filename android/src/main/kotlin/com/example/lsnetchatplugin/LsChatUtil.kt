package com.example.lsnetchatplugin

import android.content.Context
import android.os.Environment
import android.os.Message
import android.text.TextUtils
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.netease.nimlib.NimNosSceneKeyConstant
import com.netease.nimlib.sdk.*
import com.netease.nimlib.sdk.auth.AuthService
import com.netease.nimlib.sdk.auth.AuthServiceObserver
import com.netease.nimlib.sdk.auth.LoginInfo
import com.netease.nimlib.sdk.chatroom.ChatRoomMessageBuilder
import com.netease.nimlib.sdk.chatroom.ChatRoomService
import com.netease.nimlib.sdk.chatroom.ChatRoomServiceObserver
import com.netease.nimlib.sdk.chatroom.model.*
import com.netease.nimlib.sdk.msg.MessageBuilder
import com.netease.nimlib.sdk.msg.MsgService
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

object LsChatUtil {


    ///获取聊天室详情
    fun getRoomInfo(roomId: String, @NonNull result: MethodChannel.Result) {
        NIMClient.getService(ChatRoomService::class.java).fetchRoomInfo(roomId).setCallback(object : RequestCallback<ChatRoomInfo> {
            override fun onSuccess(param: ChatRoomInfo?) {
                param?.run {
                    result.success(mapOf("code" to 0, "message" to onlineUserCount))
                }

            }

            override fun onFailed(code: Int) {
                result.success(mapOf("code" to code))
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///添加或移除消息监听
    fun addOrRemoveMessageListener(listener: Observer<List<ChatRoomMessage>>, isAdd: Boolean) {
        NIMClient.getService(ChatRoomServiceObserver::class.java).observeReceiveMessage(listener, isAdd)
    }

    ///发送文字消息
    fun sendTextMessage(message: String, nicName: String, roomId: String, @NonNull result: MethodChannel.Result) {
        val message = ChatRoomMessageBuilder.createChatRoomTextMessage(roomId, message)
//        message.chatRoomMessageExtension.senderNick = nicName
        NIMClient.getService(ChatRoomService::class.java).sendMessage(message, false).setCallback(object : RequestCallback<Void> {
            override fun onSuccess(param: Void?) {
                result.success(mapOf("code" to 0,"message" to "发送成功"))
            }

            override fun onFailed(code: Int) {
                result.success(mapOf("code" to code,"message" to "发送失败"))
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///退出聊天室
    fun exitChatRoom(roomId: String, @NonNull result: MethodChannel.Result) {
        NIMClient.getService(ChatRoomService::class.java).exitChatRoom(roomId)
        result.success(mapOf("code" to 0, "message" to "退出成功"))
    }

    ///加入聊天室
    fun enterChatRoom(roomId: String,nicName:String, @NonNull result: MethodChannel.Result) {
        if (NIMClient.getStatus() == StatusCode.LOGINED) {
            enterWithLog(roomId,nicName, result)
        } else {
            enterWithOutLog(roomId, result)
        }

    }

    ///独立进入聊天室
    private fun enterWithOutLog(roomId: String, result: MethodChannel.Result) {
        val chatRoom = EnterChatRoomData(roomId)
        NIMClient.getService(ChatRoomService::class.java).enterChatRoomEx(chatRoom, 1).setCallback(object : RequestCallback<EnterChatRoomData> {
            override fun onSuccess(param: EnterChatRoomData?) {
//                result.success(mapOf("type" to ))
            }

            override fun onFailed(code: Int) {
                result.error(code.toString(), "", "")
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///非独立进入聊天室
    private fun enterWithLog(roomId: String,nicName:String, result: MethodChannel.Result) {
        val chatRoom = EnterChatRoomData(roomId)
        chatRoom.nick = nicName
        NIMClient.getService(ChatRoomService::class.java).enterChatRoom(chatRoom).setCallback(object : RequestCallback<EnterChatRoomResultData> {
            override fun onSuccess(param: EnterChatRoomResultData?) {
                result.success(mapOf("code" to 0, "message" to "进入成功"))
            }

            override fun onFailed(code: Int) {
                result.success(mapOf("code" to code, "message" to ChatRoomResult.getEnterChatRoomMessage(code)))
            }

            override fun onException(exception: Throwable?) {
                result.success(mapOf("code" to -10, "message" to exception.toString()))
            }
        })
    }

    ///登陆
    fun login(account: String, token: String, @NonNull result: MethodChannel.Result) {
        val info = LoginInfo(account, token)
        NIMClient.getService(AuthService::class.java).login(info).setCallback(object : RequestCallback<LoginInfo> {
            override fun onSuccess(param: LoginInfo?) {
                Log.d("info", param.toString())
//                result.success(Gson().toJson(param))
                result.success(mapOf("code" to 0, "message" to "登陆成功"))
//                var message = MessageBuilder.createTextMessage("lm123456789", SessionTypeEnum.P2P,"你坏你坏你坏")
//                NIMClient.getService(MsgService::class.java).sendMessage(message,false)
            }

            override fun onFailed(code: Int) {
//                result.error(code.toString(), ChatRoomResult.getLogoutErrorMessage(code), "")
                Log.d("onFailed", code.toString())
                result.success(mapOf("code" to code, "message" to ChatRoomResult.getLogoutErrorMessage(code)))
            }

            override fun onException(exception: Throwable?) {
            }
        })

    }

    ///退出登陆
    fun logOut(result: MethodChannel.Result) {
        NIMClient.getService(AuthService::class.java).logout()
        result.success(mapOf("code" to 0))
    }


    private fun buildOptions(mContext: Context?, appKey: String): SDKOptions? {
        var options = SDKOptions()
        options?.run {
            sdkStorageRootPath = getAppCacheDir(mContext)
            this.appKey = appKey
        }
        return options
    }

    /**
     * 配置 APP 保存图片/语音/文件/log等数据的目录
     * 这里示例用SD卡的应用扩展存储目录
     */
    private fun getAppCacheDir(mContext: Context?): String? {
        var storageRootPath: String? = null
        try { // SD卡应用扩展存储区(APP卸载后，该目录下被清除，用户也可以在设置界面中手动清除)，请根据APP对数据缓存的重要性及生命周期来决定是否采用此缓存目录.
// 该存储区在API 19以上不需要写权限，即可配置 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="18"/>
            if (mContext?.externalCacheDir != null) {
                storageRootPath = mContext.externalCacheDir?.canonicalPath
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        if (TextUtils.isEmpty(storageRootPath)) { // SD卡应用公共存储区(APP卸载后，该目录不会被清除，下载安装APP后，缓存数据依然可以被加载。SDK默认使用此目录)，该存储区域需要写权限!
            storageRootPath = Environment.getExternalStorageDirectory().toString() + "/" + LsnetchatpluginPlugin.mContext?.packageName
        }
        return storageRootPath
    }

    ///添加登陆状态监听
    fun addAuthStatusListener(observer: Observer<StatusCode>, isAdd: Boolean) {
        NIMClient.getService(AuthServiceObserver::class.java).observeOnlineStatus(observer, isAdd)
    }

}