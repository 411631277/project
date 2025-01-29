import 'package:flutter/material.dart';

class ResearchAgreementWidget extends StatefulWidget {
  const ResearchAgreementWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResearchAgreementWidgetState createState() =>
      _ResearchAgreementWidgetState();
}

class _ResearchAgreementWidgetState extends State<ResearchAgreementWidget> {
  bool hasScrolledToBottom = false; // 是否已滾動到底部
  bool isChecked = false; // 是否已勾選同意

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // 檢測是否滾動到底部
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        setState(() {
          hasScrolledToBottom = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '\n\n1.研究目的',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(147, 129, 108, 1)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '疾病為具有醫學意義之特殊案例，蒐集該病例資料進行研究發表，以增進醫學知識，提升醫療品質。',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '2.研究方法',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(147, 129, 108, 1)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '整理您的病歷資料並與醫學文獻查詢比對驗證，以科學化之方法進行資料分析並做討論。',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '3.病人權利、撤回同意及撤回方式',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(147, 129, 108, 1)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '(1) 若您有任何的疑問，可向計畫主持人與研究人員詢問，將據實回答您的疑問。\n'
                      '(2) 若您對參與研究的相關個人權益有疑慮，請與三軍總醫院人體試驗審議會聯絡，電話專線: 02-2793-6995 或 E-mail: tsghirb@ndmctsgh.edu.tw。\n'
                      '(3) 您有權利拒絕或退出本研究，並不會因此影響您應有的醫療照顧。\n'
                      '(4) 研究過程中您或您的法定代理人可隨時撤銷同意。若您決定撤回同意，可與計畫主持人聯繫。',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '4.研究資料之保存方式及保護機制、保存期限',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(147, 129, 108, 1)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '(1) 計畫主持人將維護您應有之權益與隱私，並妥善保存資料。\n'
                      '(2) 研究期間，我們將會蒐集與您有關的病歷資料與資訊，以編號來代替您的名字，確保隱私。\n'
                      '(3) 所得資料僅供學術發表，您的個人資料不會被洩漏。',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '5.預期可能衍生之商業利益',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(147, 129, 108, 1)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '本研究預期不會衍生專利權或其他商業利益。',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '6.損害補償',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(147, 129, 108, 1)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '本研究依計畫執行，若因參與本研究而發生不良事件或損害，將由三軍總醫院及計畫主持人提供合理救濟措施。',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            if (hasScrolledToBottom) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: CheckboxListTile(
                  title: const Text(
                    "我已閱讀並同意參與本研究",
                    style: TextStyle(fontSize: 18),
                  ),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                  activeColor: const Color.fromRGBO(147, 129, 108, 1),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              if (isChecked)
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(147, 129, 108, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/IamWidget');
                      },
                      child: const Text(
                        "下一步",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
