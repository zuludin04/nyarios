import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? "",
  scopes: ['email'],
);

Future<GoogleSignInAuthentication> signInGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
  return googleSignInAuthentication;
}
