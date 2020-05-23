package com.example.lsnetchatplugin

import org.json.JSONObject

class ExitMessage : CustomAttachment(20) {

    var message:String = ""

    override fun parseData(data: JSONObject?) {
        message = data!!.getString("message");
    }

    override fun packData(): JSONObject? {
        val data = JSONObject()
        data.put("message","401")
        return data
    }
}