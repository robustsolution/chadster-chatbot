import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/constants/color_constant.dart';

class InputFeild extends StatefulWidget {
  final String hinntText;
  final Function validatior;
  final void Function(String?)? saved;
  final void Function(String)? submitted;
  final void Function(String)? onChanged;
  final TextEditingController inputController;
  final TextInputType? type;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool secure;
  final IconData? suffix;
  final bool readOnly;
  final Function? suffixPress;
  final int? maxLines;
  final Color? bgColor;

  InputFeild({
    required this.hinntText,
    required this.validatior,
    required this.inputController,
    this.type,
    this.focusNode,
    this.submitted,
    this.saved,
    this.suffix,
    this.maxLines = 1,
    this.suffixPress,
    this.onChanged,
    this.bgColor,
    this.textInputAction,
    this.readOnly = false,
    this.secure = false,
  });

  @override
  State<InputFeild> createState() => _InputFeildState();
}

class _InputFeildState extends State<InputFeild> {
  var isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(10),

        // boxShadow: [
        //   BoxShadow(color: Colors.grey, offset: Offset(0, 5), blurRadius: 12),
        // ],
      ),
      //  height: isError ? height * 9 : height * 7,
      //   margin: EdgeInsets.only(top: height * 3),
      child: Center(
        child: TextFormField(
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          onFieldSubmitted: widget.submitted,
          onSaved: widget.saved,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          obscureText: widget.secure,
          readOnly: widget.readOnly,
          keyboardType: widget.type,
          controller: widget.inputController,
          validator: (value) {
            var error = widget.validatior(value);
            if (error != null) {
              setState(() {
                isError = true;
              });
            } else {
              setState(() {
                isError = false;
              });
            }

            return error;
          },
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: appTheme.iconBlackColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            // suffixIcon: widget.suffix != null
            //     ? IconButton(
            //         icon: Icon(
            //           widget.suffix,
            //           color: captionColor,
            //         ),
            //         onPressed: widget.suffixPress as Function()?,
            //       )
            //     : null,
            fillColor: Colors.white,
            // contentPadding: const EdgeInsets.all(5),
            // hintStyle: TextStyle(
            //     color: captionColor, fontSize: 12, fontWeight: FontWeight.w400),
            hintText: widget.hinntText,
            border: InputBorder.none,
            focusedBorder:
                // UnderlineInputBorder(
                //   borderSide: BorderSide(color: primaryColor),
                // ),
                OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 0.0),
            ),
            enabledBorder:
                // const UnderlineInputBorder(
                //   borderSide: BorderSide(
                //     color: Color.fromRGBO(168, 167, 167, 1),
                //   ),
                // ),
                OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.5),
              borderSide: BorderSide(color: Colors.white, width: 0.0),
            ),
            errorBorder:
                // const UnderlineInputBorder(
                //   borderSide: BorderSide(color: Colors.red),
                // ),
                OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 0.0),
            ),
            focusedErrorBorder:
                //  UnderlineInputBorder(
                //   borderSide: BorderSide(color: secondaryColor),
                // ),
                OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 0.0),
            ),
            // errorStyle: Theme.of(context).textTheme.caption!.copyWith(
            //       color: Colors.red,
            //       fontSize: 10,
            //     ),
            errorStyle: const TextStyle(
              height: 0.01,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
