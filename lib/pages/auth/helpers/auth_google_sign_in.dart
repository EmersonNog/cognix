import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle({
  bool ensureDisplayName = false,
}) async {
  final googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();

  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    return null;
  }

  final googleAuth = await googleUser.authentication;
  if (googleAuth.idToken == null) {
    throw FirebaseAuthException(
      code: 'missing-google-id-token',
      message: 'Não foi possível autenticar com o Google.',
    );
  }

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential = await FirebaseAuth.instance.signInWithCredential(
    credential,
  );

  if (ensureDisplayName &&
      (userCredential.user?.displayName == null ||
          userCredential.user!.displayName!.isEmpty)) {
    final displayName =
        googleUser.displayName ?? googleUser.email.split('@').first;
    await userCredential.user?.updateDisplayName(displayName);
    await userCredential.user?.reload();
  }

  return userCredential;
}
