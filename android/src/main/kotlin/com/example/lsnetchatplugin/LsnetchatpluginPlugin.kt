package com.example.lsnetchatplugin

import android.content.Context
import android.os.Environment
import android.text.TextUtils
import androidx.annotation.NonNull
import com.google.gson.Gson
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
import com.netease.nimlib.sdk.util.api.RequestResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.IOException


/** LsnetchatpluginPlugin */
public class LsnetchatpluginPlugin : FlutterPlugin, MethodCallHandler {

    var messageListener = Observer<List<ChatRoomMessage>> {
        streamEvents?.success(Gson().toJson(it))
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
            }
            "logout" -> LsChatUtil.logOut()
            "enterChatRoom" -> {
                LsChatUtil.enterChatRoom(call.argument<String>("roomId")!!, result)
            }
            "exitChatRoom" -> LsChatUtil.exitChatRoom(call.argument<String>("roomId")!!)
            "sendTextMessage" -> LsChatUtil.sendTextMessage(call.argument<String>("message")!!, call.argument<String>("roomId")!!, result)
            "messageListener" -> {
                LsChatUtil.addOrRemoveMessageListener(messageListener, true)
            }
            "removeMessageListener" -> {
                LsChatUtil.addOrRemoveMessageListener(messageListener, false)
            }
            "roomInfo" -> {
                LsChatUtil.getRoomInfo(call.argument<String>("roomId")!!, result)
            }

        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }


}
