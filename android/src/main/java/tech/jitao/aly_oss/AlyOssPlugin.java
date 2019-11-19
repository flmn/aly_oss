package tech.jitao.aly_oss;

import com.alibaba.sdk.android.oss.ClientConfiguration;
import com.alibaba.sdk.android.oss.ClientException;
import com.alibaba.sdk.android.oss.OSS;
import com.alibaba.sdk.android.oss.OSSClient;
import com.alibaba.sdk.android.oss.ServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.common.OSSConstants;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSFederationCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSFederationToken;
import com.alibaba.sdk.android.oss.common.utils.IOUtils;
import com.alibaba.sdk.android.oss.model.DeleteObjectRequest;
import com.alibaba.sdk.android.oss.model.PutObjectRequest;
import com.alibaba.sdk.android.oss.model.PutObjectResult;
import com.google.common.collect.Maps;

import org.json.JSONObject;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
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
            case "exist":
                exist(call, result);
                break;
            case "delete":
                delete(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void init(MethodCall call, Result result) {
        final String instanceId = call.argument("instanceId");
        final String stsServer = call.argument("stsServer");
        final String endpoint = call.argument("endpoint");
        final String aesKey = call.argument("aesKey");
        final String iv = call.argument("iv");
        final OSSCredentialProvider credentialProvider = new OSSFederationCredentialProvider() {
            @Override
            public OSSFederationToken getFederationToken() {
                try {
                    URL url = new URL(stsServer);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    InputStream input = conn.getInputStream();
                    String data = IOUtils.readStreamAsString(input, OSSConstants.DEFAULT_CHARSET_NAME);
                    String jsonText = AesHelper.decrypt(aesKey, iv, data);

                    Log.i("StsServer", jsonText);

                    JSONObject jsonObj = new JSONObject(jsonText);

                    return new OSSFederationToken(jsonObj.getString("AccessKeyId"),
                            jsonObj.getString("AccessKeySecret"),
                            jsonObj.getString("SecurityToken"),
                            jsonObj.getString("Expiration"));
                } catch (Exception e) {
                    Log.w("OSSFederationCredentialProvider", e.getMessage());
                }
                return null;
            }
        };

        final ClientConfiguration conf = new ClientConfiguration();
        conf.setConnectionTimeout(15 * 1000); // 连接超时时间，默认15秒
        conf.setSocketTimeout(15 * 1000); // Socket超时时间，默认15秒
        conf.setMaxConcurrentRequest(5); // 最大并发请求数，默认5个
        conf.setMaxErrorRetry(2); // 失败后最大重试次数，默认2次

        oss = new OSSClient(REGISTRAR.context(), endpoint, credentialProvider, conf);

        final Map<String, String> map = Maps.newHashMap();
        map.put("instanceId", instanceId);
        result.success(map);
    }

    private void upload(MethodCall call, Result result) {
        if (!checkOss(result)) {
            return;
        }

        final String instanceId = call.argument("instanceId");
        final String requestId = call.argument("requestId");
        final String bucket = call.argument("bucket");
        final String key = call.argument("key");
        final String file = call.argument("file");

        Log.i("upload", "instanceId=" + instanceId + ", bucket=" + bucket + ", key=" + key + ", file=" + file);
        PutObjectRequest request = new PutObjectRequest(bucket, key, file);
        request.setProgressCallback(new OSSProgressCallback<PutObjectRequest>() {
            @Override
            public void onProgress(PutObjectRequest request, long currentSize, long totalSize) {
                Log.d("onProgress", "currentSize: " + currentSize + " totalSize: " + totalSize);
                final Map<String, String> arguments = Maps.newHashMap();
                arguments.put("instanceId", instanceId);
                arguments.put("requestId", requestId);
                arguments.put("bucket", bucket);
                arguments.put("key", key);
                arguments.put("currentSize", String.valueOf(currentSize));
                arguments.put("totalSize", String.valueOf(totalSize));
                REGISTRAR.activity().runOnUiThread(
                        new Runnable() {
                            @Override
                            public void run() {
                                CHANNEL.invokeMethod("onProgress", arguments);
                            }
                        });
            }
        });

        oss.asyncPutObject(request, new OSSCompletedCallback<PutObjectRequest, PutObjectResult>() {

                    @Override
                    public void onSuccess(PutObjectRequest request, PutObjectResult result) {
                        Log.d("onSuccess", "RequestId: " + result.getRequestId());

                        final Map<String, String> arguments = Maps.newHashMap();
                        arguments.put("success", "true");
                        arguments.put("instanceId", instanceId);
                        arguments.put("requestId", requestId);
                        arguments.put("bucket", bucket);
                        arguments.put("key", key);
                        REGISTRAR.activity().runOnUiThread(
                                new Runnable() {
                                    @Override
                                    public void run() {
                                        CHANNEL.invokeMethod("onUpload", arguments);
                                    }
                                });
                    }

                    @Override
                    public void onFailure(PutObjectRequest request, ClientException clientException, ServiceException serviceException) {
                        final Map<String, String> arguments = Maps.newHashMap();
                        arguments.put("success", "false");
                        arguments.put("instanceId", instanceId);
                        arguments.put("requestId", requestId);
                        arguments.put("bucket", bucket);
                        arguments.put("key", key);

                        if (clientException != null) {
                            Log.w("onFailure", "ClientException: " + clientException.getMessage());

                            arguments.put("message", clientException.getMessage());
                        }

                        if (serviceException != null) {
                            Log.w("onFailure",
                                    "ServiceException: ErrorCode=" + serviceException.getErrorCode() +
                                            "RequestId" + serviceException.getRequestId() +
                                            "HostId" + serviceException.getHostId() +
                                            "RawMessage" + serviceException.getRawMessage());

                            arguments.put("message", serviceException.getRawMessage());
                        }

                        REGISTRAR.activity().runOnUiThread(
                                new Runnable() {
                                    @Override
                                    public void run() {
                                        CHANNEL.invokeMethod("onUpload", arguments);
                                    }
                                });
                    }
                }
        );

        final Map<String, String> map = Maps.newHashMap();
        map.put("instanceId", instanceId);
        map.put("requestId", requestId);
        map.put("bucket", bucket);
        map.put("key", key);

        result.success(map);
    }

    private void exist(MethodCall call, Result result) {
        if (!checkOss(result)) {
            return;
        }

        final String instanceId = call.argument("instanceId");
        final String requestId = call.argument("requestId");
        final String bucket = call.argument("bucket");
        final String key = call.argument("key");

        try {
            final Map<String, String> map = Maps.newHashMap();
            map.put("instanceId", instanceId);
            map.put("requestId", requestId);
            map.put("bucket", bucket);
            map.put("key", key);

            if (oss.doesObjectExist(bucket, key)) {
                map.put("exist", "true");
            } else {
                map.put("exist", "false");
            }

            result.success(map);
        } catch (ClientException e) {
            Log.w("doesObjectExist", "ClientException: " + e.getMessage());

            result.error(ErrorCodes.CLIENT_EXCEPTION, e.getMessage(), null);
        } catch (ServiceException e) {
            Log.w("doesObjectExist", "ServiceException: " + e.getRawMessage());

            result.error(ErrorCodes.SERVICE_EXCEPTION, e.getMessage(), e.getRawMessage());
        }
    }

    private void delete(MethodCall call, Result result) {
        if (!checkOss(result)) {
            return;
        }

        final String instanceId = call.argument("instanceId");
        final String requestId = call.argument("requestId");
        final String bucket = call.argument("bucket");
        final String key = call.argument("key");


        DeleteObjectRequest request = new DeleteObjectRequest(bucket, key);

        try {
            oss.deleteObject(request);
            final Map<String, String> map = Maps.newHashMap();
            map.put("instanceId", instanceId);
            map.put("requestId", requestId);
            map.put("bucket", bucket);
            map.put("key", key);

            result.success(map);
        } catch (ClientException e) {
            Log.w("deleteObject", "ClientException: " + e.getMessage());

            result.error(ErrorCodes.CLIENT_EXCEPTION, e.getMessage(), null);
        } catch (ServiceException e) {
            Log.w("deleteObject", "ServiceException: " + e.getRawMessage());

            result.error(ErrorCodes.SERVICE_EXCEPTION, e.getMessage(), e.getRawMessage());
        }
    }

    private boolean checkOss(Result result) {
        if (oss == null) {
            result.error(ErrorCodes.FAILED_PRECONDITION, "not initialized", "call init first");

            return false;
        }

        return true;
    }
}
