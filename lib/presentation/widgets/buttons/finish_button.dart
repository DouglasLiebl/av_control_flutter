import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FinishButton extends StatefulWidget {
  final String value;
  final bool isLoading;
  final AsyncCallback onPress;

  const FinishButton({
    super.key,
    required this.value,
    required this.isLoading,
    required this.onPress
  });

  @override
  State<StatefulWidget> createState() => _FinishButtonState();

}

class _FinishButtonState extends State<FinishButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: DefaultColors.activeBgGreen(),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading 
            ? null 
            : () async {
              FocusScope.of(context).unfocus();
              await widget.onPress();               
            },
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return DefaultColors.activeGreen().withOpacity(0.1);
                }
                return null;
              },
            ),
            borderRadius: BorderRadius.circular(9999),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.isLoading
                  ? SizedBox(
                    height: 22,
                    width: 22, 
                    child: CircularProgressIndicator(
                      color: DefaultColors.activeGreen(),
                      strokeWidth: 3,
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_outlined, 
                        size: 20, 
                        color: DefaultColors.activeGreen()
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: DefaultColors.activeGreen(),
                          fontFamily: "JetBrains Mono"
                        ),
                      ),
                    ],
                  ), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}