package com.example.lsnetchatplugin

import com.netease.nimlib.sdk.msg.attachment.MsgAttachment
import org.json.JSONObject


abstract class CustomAttachment internal constructor(var type: Int) : MsgAttachment {

    fun fromJson(data: JSONObject?) {
        data?.let { parseData(it) }
    }

    override fun toJson(send: Boolean): String {
        return CustomAttachParser.packData(type, packData())
    }

    protected abstract fun parseData(data: JSONObject?)
    protected abstract fun packData(): JSONObject?

}