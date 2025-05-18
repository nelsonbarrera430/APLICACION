import 'package:appwrite/appwrite.dart';
import 'constants.dart';

Client client = Client()
  .setEndpoint(AppwriteConstants.endpoint)
  .setProject(AppwriteConstants.projectId)
  .setSelfSigned(status: true);

final Account account = Account(client);
final Databases databases = Databases(client);
// Puedes inicializar otros servicios aquí (Storage, Functions, etc.)