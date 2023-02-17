///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
extension StringEx on String? {
  String? get emptyToNull {
    if (this == null) {
      return null;
    }
    if (this?.isEmpty == true) {
      return null;
    }
    return this;
  }
}
