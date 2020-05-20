package com.example.lsnetchatplugin

import android.content.Context
import android.os.Environment
import android.text.TextUtils
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.netease.nimlib.sdk.*
import com.netease.nimlib.sdk.auth.AuthService
import com.netease.nimlib.sdk.auth.LoginInfo
import com.netease.nimlib.sdk.chatroom.ChatRoomMessageBuilder
import com.netease.nimlib.sdk.chatroom.ChatRoomService
import com.netease.nimlib.sdk.chatroom.ChatRoomServiceObserver
import com.netease.nimlib.sdk.chatroom.model.ChatRoomInfo
import com.netease.nimlib.sdk.chatroom.model.ChatRoomMessage
import com.netease.nimlib.sdk.chatroom.model.ChatRoomNotificationAttachment
import com.netease.nimlib.sdk.chatroom.model.EnterChatRoomData
import com.netease.nimlib.sdk.msg.MessageBuilder
import com.netease.nimlib.sdk.msg.MsgService
import com.netease.nimlib.sdk.msg.MsgServiceObserve
import com.netease.nimlib.sdk.msg.constant.MsgTypeEnum
import com.netease.nimlib.sdk.msg.constant.NotificationType
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum
import com.netease.nimlib.sdk.util.api.RequestResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.reactivex.rxjava3.core.Observable
import java.io.IOException


/** LsnetchatpluginPlugin */
public class LsnetchatpluginPlugin : FlutterPlugin, MethodCallHandler {

    ///聊天室消息监听
    private val messageListener = Observer<List<ChatRoomMessage>> {
        it.forEach {
            if (it.msgType == MsgTypeEnum.notification) {
                Log.d("测试", "恭迎大爹${(it.attachment as ChatRoomNotificationAttachment).operatorNick}进入直播间")
            } else {
                Log.d("测试", "看大爹${it.chatRoomMessageExtension.senderNick}发了一条消息：${it.content}类型${it.msgType.value}")
            }
        }

        Observable.fromIterable(it).filter { messageData ->
            messageData.msgType == MsgTypeEnum.notification
        }.subscribe {

        }

        streamEvents?.success(mapOf("type" to ChatRoomResult.receiveMessage, "data" to buildMessage(it).toList()))
    }

    private fun buildMessage(it: List<ChatRoomMessage>): List<Map<String, Any>> {
        return it.map { message ->
            mapOf("content" to if (message.msgType.value == 0) message.content else {
                if ((message.attachment as ChatRoomNotificationAttachment).type.value == 301) {
                    "进入直播间"
                } else if ((message.attachment as ChatRoomNotificationAttachment).type.value == 302) {
                    "离开直播间"
                } else "未知"
            }
                    , "nicName" to if (message.msgType.value == 0) message.chatRoomMessageExtension.senderNick else (message.attachment as ChatRoomNotificationAttachment).operatorNick
                    , "msgType" to message.msgType.value)
        }
    }

    ///在线状态
    private val statusListener = Observer<StatusCode> {
        streamEvents?.success(mapOf("type" to ChatRoomResult.login, "data" to it.value))
    }


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "lsnetchatplugin")
        channel.setMethodCallHandler(this)
        mContext = flutterPluginBinding.applicationContext
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "lsnetchatplugin_e")
        eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                streamEvents = events
            }

            override fun onCancel(arguments: Any?) {

            }
        })
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        var eventChannel: EventChannel? = null
        var mContext: Context? = null
        var streamEvents: EventChannel.EventSink? = null
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "lsnetchatplugin")
            mContext = registrar.activity().applicationContext
            eventChannel = EventChannel(registrar.messenger(), "lsnetchatplugin_e")
            channel.setMethodCallHandler(LsnetchatpluginPlugin())
            eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    streamEvents = events
                }

                override fun onCancel(arguments: Any?) {

                }
            })
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
//            "initChatUtil" -> LsChatUtil.initChat(mContext,call.argument<String>("appKey")!!)
            "login" -> {
                LsChatUtil.login(call.argument<String>("account")!!, call.argument<String>("token")!!, result)
                LsChatUtil.addAuthStatusListener(statusListener, true)
                LsChatUtil.addOrRemoveMessageListener(messageListener, true)
                NIMClient.getService(MsgServiceObserve::class.java).observeReceiveMessage({
                    it.forEach {

                        Log.d("网易云信聊天数据", it.content)
                    }
                }, true)
            }
            "logout" -> LsChatUtil.logOut(result)
            "enterChatRoom" -> {

                LsChatUtil.enterChatRoom(call.argument<String>("roomId")!!, call.argument<String>("nicName")!!, result)
            }
            "exitChatRoom" -> LsChatUtil.exitChatRoom(call.argument<String>("roomId")!!, result)
            "sendTextMessage" -> LsChatUtil.sendTextMessage(call.argument<String>("message")!!, call.argument<String>("nicName")!!, call.argument<String>("roomId")!!, result)
            "messageListener" -> {
                LsChatUtil.addOrRemoveMessageListener(messageListener, true)
            }
            "removeMessageListener" -> {
                LsChatUtil.addOrRemoveMessageListener(messageListener, false)
            }
            "roomInfo" -> {
                LsChatUtil.getRoomInfo(call.argument<String>("roomId")!!, result)
            }
            "removeListener" -> {
                LsChatUtil.addAuthStatusListener(statusListener, false)
            }
            "sendTextMessage2Friend" -> {
//                LsChatUtil.sendMessage2F()
            }

        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }


}
