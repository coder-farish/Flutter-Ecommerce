import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Map<String, dynamic> user = {
      'fullName': 'Muhammad Farhan',
      'email': 'farhan.muhammad@ptclgroup.com',
      'number': '+923312218909',
      'address': 'Karachi, Pakistan'
    };

    return Scaffold(
      //appBar: AppBar(
      //title: Text('Profile', style: theme.appBarTheme.titleTextStyle),
      //  ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/farhan.jpg'),
                backgroundColor: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user['fullName'] ?? 'Full Name',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user['email'] ?? 'Email Address',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              user['number'] ?? 'Contact',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              user['address'] ?? 'Address',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            _buildProfileOption(
              context,
              icon: Icons.history,
              text: 'Order History',
              onTap: () {
                Navigator.pushNamed(context, '/ordersm');
              },
            ),
            const SizedBox(height: 8),
            _buildProfileOption(
              context,
              icon: Icons.help_outline,
              text: 'FAQs',
              onTap: () => _showFaqsModal(context),
            ),
            const SizedBox(height: 8),
            _buildProfileOption(
              context,
              icon: Icons.contact_mail,
              text: 'Contact Us',
              onTap: () => _showContactUsModal(context),
            ),
            const SizedBox(height: 8),
            _buildProfileOption(
              context,
              icon: Icons.admin_panel_settings,
              text: 'Admin Access',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        text,
        style: theme.textTheme.bodyMedium,
      ),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      tileColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showFaqsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery FAQs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  '1. What delivery options do you offer?\n'
                  'We offer a range of delivery options including standard shipping, expedited shipping, and next-day delivery. Delivery times and costs vary depending on your location and the shipping method selected.\n\n'
                  '2. How can I track my order?\n'
                  'Once your order has shipped, you will receive a confirmation email with a tracking number. You can use this number to track your order on our website or through the carrier\'s tracking system.\n\n'
                  '3. What should I do if my order hasn\'t arrived yet?\n'
                  'If your order has not arrived by the estimated delivery date, please contact our customer service team with your order number. We will investigate the issue and provide an update.\n\n'
                  '4. Can I change my delivery address after placing an order?\n'
                  'If you need to change your delivery address, please contact our customer service team as soon as possible. We can update your address as long as your order has not yet been dispatched.\n\n'
                  '5. What should I do if I receive a damaged or incorrect item?\n'
                  'If you receive a damaged or incorrect item, please contact our customer service team immediately. Provide your order number, a description of the issue, and any relevant photos. We will arrange for a replacement or refund as needed.\n\n'
                  '6. Are there any delivery charges?\n'
                  'Delivery charges depend on the shipping method and destination. Standard shipping is usually free for orders over a certain amount. For more information on delivery charges, please refer to our shipping policy.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  'Return FAQs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  '1. What is your return policy?\n'
                  'We offer a 30-day return policy. Items must be returned in their original condition, with all tags attached. Some items may be non-returnable due to hygiene reasons, such as underwear or swimwear.\n\n'
                  '2. How do I return an item?\n'
                  'To return an item, please follow these steps:\n'
                  '1. Contact our customer service team to request a return authorization.\n'
                  '2. Pack the item securely in its original packaging.\n'
                  '3. Include the return authorization number and a copy of your receipt.\n'
                  '4. Ship the item back to us using the provided return label.\n\n'
                  '3. How long does it take to process a return?\n'
                  'Once we receive your returned item, it usually takes 5-7 business days to process the return and issue a refund. You will receive an email notification once your return has been processed.\n\n'
                  '4. Can I exchange an item instead of returning it?\n'
                  'Currently, we do not offer direct exchanges. If you need a different item, please return the original item for a refund and place a new order for the desired item.\n\n'
                  '5. Are return shipping costs covered?\n'
                  'If the return is due to a mistake on our part or a defective item, return shipping costs will be covered by us. For other returns, the customer is responsible for the return shipping costs unless otherwise stated.\n\n'
                  '6. How will I receive my refund?\n'
                  'Refunds are issued to the original payment method used for the purchase. It may take 5-7 business days from the date we process the return for the refund to appear in your account.\n\n'
                  '7. What if I lost my receipt?\n'
                  'If you have lost your receipt, please contact our customer service team. We may be able to assist you with your return using your order number or other purchase details.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactUsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Email: support@ffmstore.com\n\n'
                  'Phone: +123 456 7890\n\n'
                  'Address: 1234 5th Street, Karachi, PAK\n\n'
                  'Customer Service Hours:\n'
                  'Monday - Friday: 9:00 AM - 6:00 PM (PST)\n'
                  'Saturday: 10:00 AM - 4:00 PM (PST)\n'
                  'Sunday: Closed\n\n'
                  'For inquiries or support, please reach out to us via email or phone. We aim to respond to all queries within 24 hours.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
