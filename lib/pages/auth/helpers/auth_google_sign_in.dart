import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
Future<void>? _googleSignInInit;

Future<void> _ensureGoogleSignInInitialized() {
  return _googleSignInInit ??= _googleSignIn.initialize();
}

Future<UserCredential?> signInWithGoogle({
  bool ensureDisplayName = false,
}) async {
  await _ensureGoogleSignInInitialized();
  await _googleSignIn.signOut();

  GoogleSignInAccount googleUser;
  try {
    googleUser = await _googleSignIn.authenticate();
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      return null;
    }
    rethrow;
  }

  final googleAuth = googleUser.authentication;
  if (googleAuth.idToken == null) {
    throw FirebaseAuthException(
      code: 'missing-google-id-token',
      message: 'Não foi possível autenticar com o Google.',
    );
  }

  final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

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

Future<bool> reauthenticateWithGoogle(User user) async {
  await _ensureGoogleSignInInitialized();
  await _googleSignIn.signOut();

  GoogleSignInAccount googleUser;
  try {
    googleUser = await _googleSignIn.authenticate();
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      return false;
    }
    rethrow;
  }

  final googleAuth = googleUser.authentication;
  if (googleAuth.idToken == null) {
    throw FirebaseAuthException(
      code: 'missing-google-id-token',
      message: 'Não foi possível autenticar com o Google.',
    );
  }

  final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
  await user.reauthenticateWithCredential(credential);
  return true;
}
