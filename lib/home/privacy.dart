import 'package:flutter/material.dart';
import 'dart:math' as math;

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: [
            // 主要內容區
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: screenHeight * 0.1, // 預留底部空間給返回按鈕
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 80),

                    // 以下為「醫療機構醫療隱私維護規範」文字，可依需求分段
                    Text(
                      '一、衛生福利部為規範醫療機構之醫事人員於執行醫療業務時，'
                      '應注意維護病人隱私，減少程序疑慮，以保障醫病雙方權益，特訂定本規範。',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(
                      '二、醫療機構應依本規範之規定辦理，並督導醫事人員於執行醫療業務時，'
                      '確實遵守下列事項：',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text(
                      '（一）與病人作病情說明、溝通、執行觸診或徵詢病人同意之過程中，'
                      '應考量到當時之環境，儘量保護個人之隱私。\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '（二）病人就診時，應確實隔離其他不相關人員；於診療過程，'
                      '醫病雙方如需錄音或錄影，應先徵得對方之同意。\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '（三）門診診間及諮詢會談場所應為單診間，且有適當之隔音；'
                      '診間入口並應有門隔開，且對於診間之設計，應有具體確保病人隱私之設施。\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '（四）進行檢查及處置之場所，應至少有布簾隔開，且視檢查及處置之種類，'
                      '儘量設置個別房間；檢查台應備有被單、治療巾等，對於身體私密部位之檢查，'
                      '並應有避免過度暴露之措施。\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '（五）診療過程，對於特殊檢查及處置，應依病人及處置之需要，'
                      '安排適當人員陪同，且有合適之醫事人員在場，並於檢查及處置過程中隨時觀察、注意隱私之維護。\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '（六）於診療過程中呼喚病人時，宜顧慮其權利及尊嚴；候診區就診名單之公布，'
                      '應尊重病人之意願，以不呈現全名為原則。\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '（七）教學醫院之教學門診應有明顯標示，對實（見）習學生在旁，'
                      '應事先充分告知病人；為考量病人隱私，對於身體私密部位之檢查，應徵得病人之同意。\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(
                      '三、醫療機構應依前點各款事項，訂定具體規定及完備各種設施、設備或物品；'
                      '且除確保病人之隱私外，亦應保障醫事人員之相對權益。',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(
                      '四、醫療機構應遵守性別工作平等法及性騷擾防治法規定，'
                      '建立性騷擾防治及保護之申訴管道，及指定專責人員（單位）受理申訴，'
                      '並明定處理程序，處理申訴及檢討改進診療流程。',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(147, 129, 108, 1),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // 返回按鈕
            Positioned(
              bottom: 20,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Transform.rotate(
                  angle: math.pi,
                  child: Container(
                    width: screenWidth * 0.15,
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
    );
  }
}
