import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/auth/provider/state/signin_state.dart';

class SignInNotifier extends StateNotifier<SignInState> {
  final ProfileRepository repository;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "550134906790-eo0ouqv3snr01ehpv91gq267js91rogv.apps.googleusercontent.com",
    scopes: ['email'],
  );

  SignInNotifier({required this.repository})
    : super(const SignInState.initial());

  Future<void> signIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      var auth = await _auth.signInWithCredential(credential);
      var user = auth.user;
      if (mounted) {
        state = const SignInState.loading();
        StorageServices.to.alreadyLogin = true;

        var profile = Profile(
          uid: user?.uid,
          name: user?.displayName,
          photo: user?.photoURL,
          status: 'Hey there! Let\'s be friend',
          email: user?.email,
          visibility: true,
        );

        await repository.saveUserProfile(profile);

        state = const SignInState.success();
      }
    } on FirebaseAuthException catch (e) {
      state = SignInState.error(e.message ?? "An error occurred");
    }
  }
}
