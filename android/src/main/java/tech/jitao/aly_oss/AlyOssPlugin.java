package tech.jitao.aly_oss;

import com.alibaba.sdk.android.oss.OSS;
import com.alibaba.sdk.android.oss.OSSClient;
import com.alibaba.sdk.android.oss.common.auth.OSSCustomSignerCredentialProvider;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.model.PutObjectRequest;
import com.google.common.collect.Maps;

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
    private static MethodChannel CHANNEL;
    private static Registrar REGISTRAR;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        REGISTRAR = registrar;
        CHANNEL = new MethodChannel(registrar.messenger(), "jitao.tech/aly_oss");
        CHANNEL.setMethodCallHandler(new AlyOssPlugin());
    }

    private OSS oss;

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
        String id = call.argument("id");
        String endpoint = call.argument("endpoint");
        String accessKeyId = call.argument("accessKeyId");
        String accessKeySecret = call.argument("accessKeySecret");

        final Map<String, String> m1 = Maps.newHashMap();
        m1.put("code", "OK");
        m1.put("id", id);

        final OSSCustomSignerCredentialProvider credentialProvider = new OSSCustomSignerCredentialProvider() {
            @Override
            public String signContent(String content) {
                return OSSUtils.sign("", "", content);
            }
        };
        oss = new OSSClient(REGISTRAR.context(), endpoint, credentialProvider);

        Log.i("before", "endpoint=" + endpoint);
        CHANNEL.invokeMethod("onInit", m1);
        Log.i("after", "endpoint=" + endpoint);
        Log.i("init", "endpoint=" + endpoint);

        CHANNEL.invokeMethod("aaa", null);

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
        PutObjectRequest put = new PutObjectRequest(bucket, key, file);

        Map<String, Object> map = new HashMap<>();
        map.put("r", 1);

        result.success(map);
    }
}
