import '../../domain/security/capability.dart';

class CapabilityGate {
  final Set<Capability> granted;

  CapabilityGate(this.granted);

  bool can(Capability capability) => granted.contains(capability);

  void require(Capability capability) {
    if (!can(capability)) {
      throw Exception('Capability $capability not granted');
    }
  }
}
