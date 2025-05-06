import 'package:appwrite/appwrite.dart';
import 'constants.dart';

Client client = Client()
    .setEndpoint(AppwriteConstants.endpoint)
    .setProject(AppwriteConstants.projectId)
    .setSelfSigned(status: true);
