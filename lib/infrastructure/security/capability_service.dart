import '../../domain/security/capability.dart';

/// Capability-based access control.
///
/// Each sensitive action is guarded by a capability which must be
/// explicitly granted (e.g. via a settings screen or confirmation dialog).
abstract class CapabilityService {
  Future<bool> hasCapability(Capability capability);

  Future<void> requestCapability(Capability capability);
}

