import 'package:flutter/material.dart';

class TermsOfServiceBottomSheet extends StatelessWidget {
  const TermsOfServiceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Swype App. By using our services, you agree to the following terms and conditions. Please read them carefully.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      // Point 1
                      Text(
                        '1. Acceptance of Terms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'By accessing or using Swype App, you agree to comply with and be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, please do not use our services.',
                      ),
                      SizedBox(height: 10),

                      // Point 2
                      Text(
                        '2. Changes to Terms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new terms on this page. It is your responsibility to review these terms periodically for any changes.',
                      ),
                      SizedBox(height: 10),

                      // Point 3
                      Text(
                        '3. User Accounts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You may need to create an account to use some features of Swype App. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.',
                      ),
                      SizedBox(height: 10),

                      // Point 4
                      Text(
                        '4. Use of the Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You agree to use Swype App only for lawful purposes and in accordance with these Terms.',
                      ),
                      SizedBox(height: 10),

                      // Point 5
                      Text(
                        '5. Content Ownership',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'All content, features, and functionality on Swype App, including but not limited to text, graphics, logos, images, as well as the software used to provide the services, are the exclusive property of Swype App and are protected by copyright, trademark, and other intellectual property laws.',
                      ),
                      SizedBox(height: 10),

                      // Point 6
                      Text(
                        '6. Disclaimer of Warranties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'The services are provided on an "as-is" and "as available" basis without any warranties of any kind, either express or implied.',
                      ),
                      SizedBox(height: 10),

                      // Point 7
                      Text(
                        '7. Limitation of Liability',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'To the fullest extent permitted by law, Swype App shall not be liable for any direct, indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, or use, arising out of or in connection with your use of the services.',
                      ),
                      SizedBox(height: 10),

                      // Point 8
                      Text(
                        '8. Indemnification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You agree to indemnify, defend, and hold harmless Swype App and its affiliates from any claims, liabilities, damages, losses, costs, or expenses (including reasonable attorney fees) arising out of or in connection with your use of the services.',
                      ),
                      SizedBox(height: 10),

                      // Point 9
                      Text(
                        '9. Governing Law',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'These Terms of Service shall be governed by and construed in accordance with the laws of [Insert State/Country], without regard to its conflict of law provisions.',
                      ),
                      SizedBox(height: 10),

                      // Point 10
                      Text(
                        '10. Contact Us',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'If you have any questions about these Terms of Service, please contact us at [Insert Contact Information].',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
