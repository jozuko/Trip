///
/// Created by r.mori on 2023/02/16.
/// Copyright (c) 2023 rei-frontier. All rights reserved.
///
class Global {
  Global._();

  static const isRelease = bool.fromEnvironment('dart.vm.product');
}