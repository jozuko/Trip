import 'package:trip/widget/field/single_line_field.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class EmailField extends SingleLineField {
  const EmailField({
    super.key,
    super.labelText = 'メールアドレス',
    super.hintText = 'aaa@bbb.com',
    super.value,
    super.textInputType,
    super.textInputAction,
    super.errorText,
    super.focusNode,
    super.onChanged,
  });
}
