import '../../../import_data.dart';

class PayzoAppBarInVoiceCard extends StatelessWidget {
  final String text;
  final String number;
  final bool isLoading; // NEW
  final VoidCallback? onTap; // NEW

  const PayzoAppBarInVoiceCard({
    super.key,
    required this.text,
    required this.number,
    this.isLoading = false,
    this.onTap, // default false
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Expanded(
        child: ReusablePadding(
          padding: const EdgeInsets.only(top: 8),
          child: GestureDetector(
            onTap: onTap,
            child: ReusableContainer(
              height: 104,
              color: AppColors.appMainColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                width: 116,
                height: 64,
                child: ReusablePadding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, bottom: 20, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        color: const Color(0xFF0C0C0C),
                        fontSize: 12,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                        height: 1.52,
                        text: text,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          isLoading
                              ? const ReusableSizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : ReusableText(
                                  text: number,
                                  color: const Color(0xFF0C0C0C),
                                  fontSize: 32,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                  height: 0.57,
                                ),
                          const SizedBox(width: 75),
                          ReusableSizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              'assets/chevron-right.svg',
                              fit: BoxFit.cover,
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
        ),
      ),
    );
  }
}
