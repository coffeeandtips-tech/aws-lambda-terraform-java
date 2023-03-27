package coffee.tips.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;


import java.util.Map;

public class Handler implements RequestHandler<Map<String, Object>, Void> {

    @Override
    public Void handleRequest(Map<String, Object> input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("Hello Lambda triggered by EventBridge (Cloudwatch Events)");
        return null;
    }
}
