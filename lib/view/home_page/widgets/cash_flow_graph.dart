import 'package:payzo_books/import_data.dart';
class CashFlowGraph extends StatelessWidget {
  const CashFlowGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 339,
      height: 171,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 21,
              height: 138,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        '\$5K',
                        style: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 10,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 51),
                  SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        '\$3K',
                        style: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 10,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 51),
                  SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        '\$1K',
                        style: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 10,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 11,
            child: Opacity(
              opacity: 0.50,
              child: Container(
                width: 314,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFB1B1B1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 74,
            child: Opacity(
              opacity: 0.50,
              child: Container(
                width: 314,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFB1B1B1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 137,
            child: Opacity(
              opacity: 0.50,
              child: Container(
                width: 314,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFB1B1B1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 284.06,
            top: 136.79,
            child: Transform(
              transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-1.57),
              child: Container(
                width: 136.79,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFF4D61FD),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 282,
            top: 55.84,
            child: Container(
              width: 4.13,
              height: 4.13,
              decoration: const ShapeDecoration(
                color: Color(0xFF0014AB),
                shape: OvalBorder(
                  side: BorderSide(
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Color(0xFF4D61FD),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 147,
            child: Container(
              width: 286,
              height: 24,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                    child: SizedBox(
                      width: 15,
                      child: Text(
                        'Apr\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 19,
                    child: SizedBox(
                      width: 19,
                      child: Text(
                        'May\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Jun\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 13,
                    child: SizedBox(
                      width: 13,
                      child: Text(
                        'Jul\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Aug\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Sep\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Oct\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Nov\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Dec\n24',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Jan\n25',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 16,
                    child: SizedBox(
                      width: 16,
                      child: Text(
                        'Feb\n25',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.50),
                  SizedBox(
                    width: 17,
                    child: SizedBox(
                      width: 17,
                      child: Text(
                        'Mar\n25',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 8,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
