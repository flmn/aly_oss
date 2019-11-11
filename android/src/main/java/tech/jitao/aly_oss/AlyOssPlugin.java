package tech.jitao.aly_oss;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AlyOssPlugin
 */
public class AlyOssPlugin implements MethodCallHandler {
    private static MethodChannel channel;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), "jitao.tech/aly_oss");
        channel.setMethodCallHandler(new AlyOssPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "init":
                init(call, result);
                break;
            case "upload":
                upload(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void init(MethodCall call, Result result) {
        String endpoint = call.argument("endpoint");

        Log.i("init","endpoint="+endpoint);

                channel.invokeMethod("aaa", null);

        Map<String, Object> map = new HashMap<>();
        map.put("r", 1);

        result.success(map);
    }

    private void upload(MethodCall call, Result result) {
        String id = call.argument("id");
        String bucket = call.argument("bucket");
        String key = call.argument("key");
        String file = call.argument("file");

        Log.i("upload", "id=" + id + ", bucket=" + bucket + ", key=" + key + ", file=" + file);
//        PutObjectRequest put = new PutObjectRequest(bucket, key, file);

        Map<String, Object> map = new HashMap<>();
        map.put("r", 1);

        result.success(map);
    }
}
