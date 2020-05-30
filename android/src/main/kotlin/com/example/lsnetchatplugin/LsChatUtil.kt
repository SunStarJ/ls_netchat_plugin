package com.example.lsnetchatplugin

import android.content.Context
import android.os.Environment
import android.text.TextUtils
import android.util.Log
import androidx.annotation.NonNull
import com.example.lsnetchatplugin.pluginData.RoomData
import com.google.gson.Gson
import com.netease.nimlib.sdk.*
import com.netease.nimlib.sdk.auth.AuthService
import com.netease.nimlib.sdk.auth.AuthServiceObserver
import com.netease.nimlib.sdk.auth.LoginInfo
import com.netease.nimlib.sdk.chatroom.ChatRoomMessageBuilder
import com.netease.nimlib.sdk.chatroom.ChatRoomService
import com.netease.nimlib.sdk.chatroom.ChatRoomServiceObserver
import com.netease.nimlib.sdk.chatroom.model.*
import io.flutter.plugin.common.MethodChannel
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.schedulers.Schedulers
import okhttp3.OkHttpClient
import okhttp3.Request
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

    fun sendPlayerExitMessage(roomId: String, result: MethodChannel.Result) {
        val attachment = ExitMessage()
        val message = ChatRoomMessageBuilder.createChatRoomCustomMessage(roomId, attachment)
        NIMClient.getService(ChatRoomService::class.java).sendMessage(message, false).setCallback(object : RequestCallback<Void> {
            override fun onSuccess(param: Void?) {
                result.success(mapOf("code" to 0, "message" to "发送成功"))
            }

            override fun onFailed(code: Int) {
                result.success(mapOf("code" to code, "message" to "发送失败"))
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///发送文字消息
    fun sendTextMessage(message: String, nicName: String, roomId: String, @NonNull result: MethodChannel.Result) {
        val message = ChatRoomMessageBuilder.createChatRoomTextMessage(roomId, message)
//        message.chatRoomMessageExtension.senderNick = nicName
        NIMClient.getService(ChatRoomService::class.java).sendMessage(message, false).setCallback(object : RequestCallback<Void> {
            override fun onSuccess(param: Void?) {
                result.success(mapOf("code" to 0, "message" to "发送成功"))
            }

            override fun onFailed(code: Int) {
                result.success(mapOf("code" to code, "message" to "发送失败"))
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


    ///独立进入聊天室
    fun enterWithOutLog(roomId: String, url: String, result: MethodChannel.Result) {
        Log.d("=======独立进入请求地址=====>", url)
        val chatRoom = EnterChatRoomData(roomId)
        chatRoom.nick = "游客${System.currentTimeMillis()}"
        chatRoom.avatar = "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1590201325&di=e27a648c7fc2bb0582e9a1fdd21af9b1&src=http://a0.att.hudong.com/64/76/20300001349415131407760417677.jpg"
        Observable.just(url).map {
            var resultList = mutableListOf<String>()
            var roomData: RoomData? = null
            roomData = Gson().fromJson<RoomData>(HttpUtils.doGet(url), RoomData::class.java)
            roomData?.run {
                resultList = data!!
            }
            Log.d("=======独立进入地址=====>", "啦啦啦啦啦")
            resultList;
        }.subscribeOn(Schedulers.newThread()).observeOn(AndroidSchedulers.mainThread()).subscribe {
            chatRoom.setIndependentMode({ roomId, account ->
                it
            }, null, null)
            NIMClient.getService(ChatRoomService::class.java).enterChatRoomEx(chatRoom, 1).setCallback(object : RequestCallback<EnterChatRoomResultData> {
                override fun onSuccess(param: EnterChatRoomResultData?) {
                    Log.d("=======独立进入=====>", "进入成功")
                    result.success(mapOf("code" to 0, "message" to "进入成功"))
                }

                override fun onFailed(code: Int) {
                    Log.d("=======独立进入=====>", ChatRoomResult.getEnterChatRoomMessage(code))
                    result.success(mapOf("code" to code, "message" to ChatRoomResult.getEnterChatRoomMessage(code)))
                }

                override fun onException(exception: Throwable?) {
                    Log.d("=======独立进入=====>", exception.toString())
                    result.success(mapOf("code" to -10, "message" to exception.toString()))
                }
            })
        }

    }

    ///非独立进入聊天室
    fun enterWithLog(roomId: String, nicName: String, result: MethodChannel.Result) {
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