import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';

class MockUserCredential extends Mock implements UserCredential {}

@GenerateMocks([FirebaseAuth, Firebase])
void main() {}