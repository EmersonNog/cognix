part of '../account_security_screen.dart';

extension _AccountSecurityActions on _AccountSecurityScreenState {
  Future<void> _handlePasswordUpdate() async {
    final user = _currentUser;
    if (user == null) {
      _showMessage(
        'Sua sessão expirou. Entre novamente para atualizar a senha.',
        type: CognixMessageType.error,
      );
      return;
    }
    if (!_supportsPasswordProvider) {
      _showMessage(
        'Sua conta não usa senha local. O acesso é gerenciado pelo provedor atual.',
      );
      return;
    }

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.length < 6) {
      _showMessage('Informe sua senha atual para confirmar a alteração.');
      return;
    }
    if (newPassword.length < 6) {
      _showMessage('A nova senha precisa ter ao menos 6 caracteres.');
      return;
    }
    if (newPassword != confirmPassword) {
      _showMessage('A confirmação da nova senha não confere.');
      return;
    }
    if (newPassword == currentPassword) {
      _showMessage('Escolha uma senha nova diferente da atual.');
      return;
    }

    _applyState(() => _isUpdatingPassword = true);
    try {
      await _reauthenticateWithPassword(currentPassword);
      await user.updatePassword(newPassword);
      if (!mounted) {
        return;
      }
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _showMessage(
        'Senha atualizada com sucesso.',
        type: CognixMessageType.success,
      );
    } on FirebaseAuthException catch (error) {
      _showMessage(
        authErrorMessage(error.code, action: AuthAction.updatePassword),
        type: CognixMessageType.error,
      );
    } catch (_) {
      _showMessage(
        'Não foi possível atualizar sua senha agora. Tente novamente.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        _applyState(() => _isUpdatingPassword = false);
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    final user = _currentUser;
    if (user == null) {
      _showMessage(
        'Sua sessão expirou. Entre novamente para excluir a conta.',
        type: CognixMessageType.error,
      );
      return;
    }

    if (_deleteConfirmationController.text.trim().toUpperCase() !=
        _AccountSecurityScreenState._deleteConfirmationText) {
      _showMessage('Digite EXCLUIR para liberar a exclusão definitiva.');
      return;
    }

    if (_supportsPasswordProvider &&
        _deletePasswordController.text.trim().length < 6) {
      _showMessage('Confirme sua senha atual para continuar.');
      return;
    }

    final confirmed = await _showDeleteConfirmationDialog();
    if (!confirmed) {
      return;
    }

    _applyState(() => _isDeletingAccount = true);
    try {
      if (_supportsPasswordProvider) {
        await _reauthenticateWithPassword(_deletePasswordController.text);
      } else if (_supportsGoogleProvider) {
        final didReauthenticate = await reauthenticateWithGoogle(user);
        if (!didReauthenticate) {
          _showMessage('Confirmação com Google cancelada.');
          return;
        }
        await user.getIdToken(true);
      } else {
        await user.getIdToken(true);
      }

      await deleteCurrentAccountFromBackend();
      await AvatarService.clearAvatarSeed();
      await FirebaseAuth.instance.signOut();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
    } on AccountApiException catch (error) {
      _showMessage(error.message, type: CognixMessageType.error);
    } on FirebaseAuthException catch (error) {
      _showMessage(
        authErrorMessage(error.code, action: AuthAction.deleteAccount),
        type: CognixMessageType.error,
      );
    } on GoogleSignInException catch (error) {
      _showMessage(
        googleSignInErrorMessage(error.code.name),
        type: CognixMessageType.error,
      );
    } catch (_) {
      _showMessage(
        'Não foi possível excluir sua conta agora. Tente novamente.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        _applyState(() => _isDeletingAccount = false);
      }
    }
  }

  Future<void> _reauthenticateWithPassword(String password) async {
    final user = _currentUser;
    final email = user?.email;
    if (user == null || email == null || email.isEmpty) {
      throw FirebaseAuthException(code: 'missing-email');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    await user.getIdToken(true);
  }
}
