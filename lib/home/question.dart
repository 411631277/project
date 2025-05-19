import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

class QuestionWidget extends StatefulWidget {
  final String userId; // 接收 userId 資訊

  const QuestionWidget({super.key, required this.userId, required bool isManUser});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final Logger logger = Logger();

  bool isLoading = true;


  Map<String, bool> surveyStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchSurveyStatus();
  }

  /// 從 Firestore 抓取使用者問卷填寫狀態
  Future<void> _fetchSurveyStatus() async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data() as Map<String, dynamic>;
        setState(() {
          // 假設 Firestore 中使用這些欄位紀錄是否完成
          surveyStatus['knowledgeCompleted'] = data['knowledgeCompleted'] ?? false;
          surveyStatus['melancholyCompleted'] = data['melancholyCompleted'] ?? false;
          surveyStatus['attachmentCompleted'] = data['attachmentCompleted'] ?? false;
          surveyStatus['painScaleCompleted'] = data['painScaleCompleted'] ?? false;
          surveyStatus['sleepCompleted'] = data['sleepCompleted'] ?? false;
          surveyStatus['roommateCompleted'] = data['roommateCompleted'] ?? false;

          isLoading = false;
        });
      } else {
        logger.w("❗ 該使用者不存在或無資料");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      logger.e("❌ 無法載入問卷狀態: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

   return PopScope(
  canPop: false, // 禁止 Flutter 自動 pop
  // ignore: deprecated_member_use
  onPopInvoked: (didPop) {
    // 不管 didPop 是 true 還是 false，一律自己導回去
    Navigator.pushReplacementNamed(
      context,
      '/HomeScreenWidget',
     arguments: {
    'userId': widget.userId,
    'isManUser': false,  
  },
    );
  },
  child: Scaffold(

      body: Container(
        width:  screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  // **問卷標題圖標**
                  Positioned(
                    top:  screenHeight * 0.08,
                    left: screenWidth  * 0.1,
                    child: Container(
                      width:  screenWidth  * 0.08,
                      height: screenHeight * 0.05,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Question.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  // **問卷文字標題**
                  Positioned(
                    top:  screenHeight * 0.085,
                    left: screenWidth  * 0.25,
                    child: Text(
                      '問卷',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromRGBO(147, 129, 108, 1),
                        fontFamily: 'Inter',
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  // **問卷選項按鈕** - 使用子方法建構
                  _buildSurveyButton(
                    context,
                    screenWidth,
                    screenHeight,
                    0.18,
                    '母乳哺餵知識量表',
                    '/KnowledgeWidget',
                    'knowledgeCompleted',
                  ),
                  _buildSurveyButton(
                    context,
                    screenWidth,
                    screenHeight,
                    0.28,
                    '產後憂鬱量表',
                    '/DourIntroduce1Page',
                    'melancholyCompleted',
                  ),
                  /*_buildSurveyButton(
                    context,
                    screenWidth,
                    screenHeight,
                    0.38,
                    '生產支持知覺量表',
                    '/ProdutionWidget',
                    'produtionCompleted',
                  ),*/
                  _buildSurveyButton(
                    context,
                    screenWidth,
                    screenHeight,
                    0.38,
                    '親子依附量表',
                    '/MaternalConnectionPage',
                    'attachmentCompleted',
                  ),
                  _buildSurveyButton(
                    context,
                    screenWidth,
                    screenHeight,
                    0.48,
                    '產後傷口疼痛分數',
                    '/PainScaleWidget',
                    'painScaleCompleted',
                  ),
                  _buildSurveyButton(
                    context,
                    screenWidth,
                    screenHeight,
                    0.58,
                    '睡眠評估問卷',
                    '/SleepIntroducePage',
                    'sleepCompleted',
                  ),
                  _buildSurveyButton(
                    context,
                    screenWidth,
                    screenHeight,
                    0.68,
                    '親子同室情況',
                    '/RoommateWidget',
                    'roommateCompleted',
                  ),

                  // **返回按鈕**
                  Positioned(
                    top:  screenHeight * 0.88,
                    left: screenWidth  * 0.1,
                    child: GestureDetector(
                     onTap: () {
  Navigator.pushNamed(
    context,
    '/HomeScreenWidget',
    arguments: {
      'userId': widget.userId,
      'isManUser': false, 
    },
  );
},
                      child: Transform.rotate(
                        angle: 180 * (math.pi / 180), // 旋轉 180 度
                        child: Container(
                          width:  screenWidth  * 0.2,
                          height: screenHeight * 0.08,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/back.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
   ));
  }

  /// 建構問卷按鈕
  /// 按鈕右側外部顯示打勾圖示
  Widget _buildSurveyButton(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    double topPosition,
    String text,
    String routeName,
    String completionKey,
  ) {
    final bool isCompleted = surveyStatus[completionKey] ?? false;

    return Positioned(
      top:  screenHeight * topPosition,
      left: screenWidth  * 0.1,
      // 讓按鈕和圖示並排
      child: Row(
        children: [
          // 1) 按鈕
          SizedBox(
            width:  screenWidth  * 0.7,
            height: screenHeight * 0.05,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(147, 129, 108, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () async {
                logger.i("🟢 正在導航到 $routeName，userId: ${widget.userId}");
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                Navigator.pop(context); // 關閉 Dialog
                Navigator.pushNamed(
                  context,
                  routeName,
                  arguments: {
    'userId': widget.userId,
    'isManUser': false, 
  },
                );
              },
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          // 2) 如果已完成，就在按鈕右側（外部）顯示綠色打勾
          if (isCompleted) ...[
            SizedBox(width: screenWidth * 0.05), // 與按鈕間留些距離
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: screenWidth * 0.06,
            ),
          ],
        ],
      ),
    );
  }
}
