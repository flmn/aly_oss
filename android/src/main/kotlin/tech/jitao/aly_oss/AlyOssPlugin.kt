package tech.jitao.aly_oss

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class AlyOssPlugin : MethodCallHandler {
    private var endpoint: String? = null

    companion object {
        @JvmField
        var channel: MethodChannel? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            println(11111111111111)

            var ch = MethodChannel(registrar.messenger(), "jitao.tech/aly_oss")

            ch.setMethodCallHandler(AlyOssPlugin())

            channel = ch
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> init(call, result)
            "upload" -> upload(call, result)
            else -> result.notImplemented()
        }
    }

    private fun init(call: MethodCall, result: Result) {
        endpoint = call.argument("endpoint")

        channel?.invokeMethod("aaa", null)

        val map = mapOf<String, Any>("r" to 1)

        result.success(map)
    }

    private fun upload(call: MethodCall, result: Result) {
        val map = mapOf<String, Any>("r" to 1)

        result.success(map)
    }
}
