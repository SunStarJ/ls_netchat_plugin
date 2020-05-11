package com.example.lsnetchatplugin

import android.content.Context
import android.os.Environment
import android.os.Message
import android.text.TextUtils
import androidx.annotation.NonNull
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.Observer
import com.netease.nimlib.sdk.RequestCallback
import com.netease.nimlib.sdk.SDKOptions
import com.netease.nimlib.sdk.auth.AuthService
import com.netease.nimlib.sdk.auth.LoginInfo
import com.netease.nimlib.sdk.chatroom.ChatRoomMessageBuilder
import com.netease.nimlib.sdk.chatroom.ChatRoomService
import com.netease.nimlib.sdk.chatroom.ChatRoomServiceObserver
import com.netease.nimlib.sdk.chatroom.model.ChatRoomInfo
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage
import com.netease.nimlib.sdk.chatroom.model.EnterChatRoomData
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

object LsChatUtil {
    ///初始化网易云信
    fun initChat(mContext: Context?) {
        NIMClient.init(mContext, null, buildOptions(mContext))
    }


    ///获取聊天室详情
    fun getRoomInfo(roomId:String,@NonNull result: MethodChannel.Result){
        NIMClient.getService(ChatRoomService::class.java).fetchRoomInfo(roomId).setCallback(object : RequestCallback<ChatRoomInfo> {
            override fun onSuccess(param: ChatRoomInfo?) {

            }

            override fun onFailed(code: Int) {
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///添加或移除消息监听
    fun addOrRemoveMessageListener(listener: Observer<List<ChatRoomMessage>>,isAdd:Boolean){
        NIMClient.getService(ChatRoomServiceObserver::class.java).observeReceiveMessage(listener, isAdd)
    }

    ///发送文字消息
    fun sendTextMessage(message:String,roomId:String,@NonNull result: MethodChannel.Result){
        val message = ChatRoomMessageBuilder.createChatRoomTextMessage(roomId,message)
        NIMClient.getService(ChatRoomService::class.java).sendMessage(message, false).setCallback(object : RequestCallback<Void> {
            override fun onSuccess(param: Void?) {

            }

            override fun onFailed(code: Int) {
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///退出聊天室
    fun exitChatRoom(roomId: String){
        NIMClient.getService(ChatRoomService::class.java).exitChatRoom(roomId)
    }

    ///加入聊天室
    fun  enterChatRoom(roomId:String,@NonNull result: MethodChannel.Result){
        val chatRoom = EnterChatRoomData(roomId)
        NIMClient.getService(ChatRoomService::class.java).enterChatRoom(chatRoom).setCallback(object : RequestCallback<EnterChatRoomData> {
            override fun onSuccess(param: EnterChatRoomData?) {

            }

            override fun onFailed(code: Int) {
                result.error(code.toString(), "", "");
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///登陆
    fun login(account: String, token: String, @NonNull result: MethodChannel.Result) {
        val info = LoginInfo(account, token)
        NIMClient.getService(AuthService::class.java).login(info).setCallback(object : RequestCallback<LoginInfo> {
            override fun onSuccess(param: LoginInfo?) {

            }

            override fun onFailed(code: Int) {
            }

            override fun onException(exception: Throwable?) {
            }
        })
    }

    ///退出登陆
    fun logOut(){
        NIMClient.getService(AuthService::class.java).logout()
    }


    private fun buildOptions(mContext: Context?): SDKOptions? {
        var options = SDKOptions()
        options?.sdkStorageRootPath = getAppCacheDir(mContext)
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

}