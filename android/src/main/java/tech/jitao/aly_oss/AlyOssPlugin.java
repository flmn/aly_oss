package tech.jitao.aly_oss;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AlyOssPlugin
 */
public class AlyOssPlugin {

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), "jitao.tech/aly_oss");
        channel.setMethodCallHandler(new MethodCallHandlerImpl(channel, registrar));
    }

}
