import 'package:flutter/material.dart';
import 'package:rm_veriphy/screens/verify_identity_screen.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/veriphy.png',
                  width: 150,
                ),
              ),
              const SizedBox(height: 40),
              
              // Title
              const Text(
                'Sign in to',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Veriphy Bank Demo',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              const Text(
                'Select your role below',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              
              // Role Buttons
              _buildRoleButton(
                context,
                'Sales',
                onTap: () => _selectRole('Sales'),
                isSelected: selectedRole == 'Sales',
              ),
              const SizedBox(height: 16),
              
              _buildRoleButton(
                context,
                'Operations',
                onTap: () => _selectRole('Operations'),
                isSelected: selectedRole == 'Operations',
              ),
              const SizedBox(height: 16),
              
              _buildRoleButton(
                context,
                'Risk',
                onTap: () => _selectRole('Risk'),
                isSelected: selectedRole == 'Risk',
              ),
              const SizedBox(height: 16),
              
              _buildRoleButton(
                context,
                'Compliance',
                onTap: () => _selectRole('Compliance'),
                isSelected: selectedRole == 'Compliance',
              ),
              
              const Spacer(),
              
              // Next Button
              if (selectedRole != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToVerification(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFa7d222),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role, {
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    const primaryColor = Color(0xFFa7d222);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            role,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? primaryColor : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void _navigateToVerification(BuildContext context) {
    if (selectedRole != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyIdentityScreen(selectedRole: selectedRole!),
        ),
      );
    }
  }
} 