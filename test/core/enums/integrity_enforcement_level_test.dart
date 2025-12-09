import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/integrity_enforcement_level.dart';

void main() {
  group('IntegrityEnforcementLevel', () {
    test('displayName returns correct values', () {
      expect(IntegrityEnforcementLevel.logOnly.displayName, equals('log_only'));
      expect(
        IntegrityEnforcementLevel.warnUser.displayName,
        equals('warn_user'),
      );
      expect(
        IntegrityEnforcementLevel.blockHighRisk.displayName,
        equals('block_high_risk'),
      );
      expect(
        IntegrityEnforcementLevel.blockAll.displayName,
        equals('block_all'),
      );
    });

    test('shouldBlock returns correct values', () {
      expect(IntegrityEnforcementLevel.logOnly.shouldBlock, isFalse);
      expect(IntegrityEnforcementLevel.warnUser.shouldBlock, isFalse);
      expect(IntegrityEnforcementLevel.blockHighRisk.shouldBlock, isTrue);
      expect(IntegrityEnforcementLevel.blockAll.shouldBlock, isTrue);
    });

    test('shouldWarn returns correct values', () {
      expect(IntegrityEnforcementLevel.logOnly.shouldWarn, isFalse);
      expect(IntegrityEnforcementLevel.warnUser.shouldWarn, isTrue);
      expect(IntegrityEnforcementLevel.blockHighRisk.shouldWarn, isTrue);
      expect(IntegrityEnforcementLevel.blockAll.shouldWarn, isTrue);
    });

    test('fromString parses correctly', () {
      expect(
        IntegrityEnforcementLevelExtension.fromString('log_only'),
        equals(IntegrityEnforcementLevel.logOnly),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('logonly'),
        equals(IntegrityEnforcementLevel.logOnly),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('warn_user'),
        equals(IntegrityEnforcementLevel.warnUser),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('WARNUSER'),
        equals(IntegrityEnforcementLevel.warnUser),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('block_high_risk'),
        equals(IntegrityEnforcementLevel.blockHighRisk),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('BlockHighRisk'),
        equals(IntegrityEnforcementLevel.blockHighRisk),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('block_all'),
        equals(IntegrityEnforcementLevel.blockAll),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('BLOCKALL'),
        equals(IntegrityEnforcementLevel.blockAll),
      );
    });

    test('fromString returns logOnly for invalid input (safe default)', () {
      expect(
        IntegrityEnforcementLevelExtension.fromString('invalid'),
        equals(IntegrityEnforcementLevel.logOnly),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString(''),
        equals(IntegrityEnforcementLevel.logOnly),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('UNKNOWN'),
        equals(IntegrityEnforcementLevel.logOnly),
      );
    });

    test('fromString is case-insensitive', () {
      expect(
        IntegrityEnforcementLevelExtension.fromString('LOG_ONLY'),
        equals(IntegrityEnforcementLevel.logOnly),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('Warn_User'),
        equals(IntegrityEnforcementLevel.warnUser),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('BLOCK_HIGH_RISK'),
        equals(IntegrityEnforcementLevel.blockHighRisk),
      );
      expect(
        IntegrityEnforcementLevelExtension.fromString('Block_All'),
        equals(IntegrityEnforcementLevel.blockAll),
      );
    });
  });
}
