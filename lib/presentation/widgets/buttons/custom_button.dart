import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String description;
  final bool isLoading;
  final AsyncCallback onPress;

  const CustomButton({
    super.key,
    required this.description,
    required this.isLoading,
    required this.onPress
  });

  @override
  State<StatefulWidget> createState() => _CustomButton();
}

class _CustomButton extends State<CustomButton> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(DefaultColors.valueGray()),
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
        ),
        elevation: MaterialStateProperty.all(5),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey.withOpacity(0.2);
            }
            return null;
          },
        ),
      ),
      onPressed: widget.isLoading ? null
      : () async {
        await widget.onPress();
      }, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.isLoading
          ? SizedBox(
            height: 22,
            width: 22, 
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 16),
              Text(
                widget.description,
                style: TextStyle(
                  fontFamily: "JetBrains Mono",
                  color: Colors.white,
                  fontSize: 18,
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}