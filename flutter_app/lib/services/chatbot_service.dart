import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotService {
  // Get API key from .env file
  String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  // Online API call using Groq
  Future<String> getOnlineResponse(String message, String language) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content': '''You are a helpful medical assistant for MediGuide, specifically designed for users in India. 
Provide accurate, helpful health information while reminding users to consult healthcare professionals for serious concerns.

CRITICAL: The user has selected $language as their preferred language. 
You MUST respond ONLY in $language. Do not respond in any other language.

FORMATTING RULES:
- DO NOT use asterisks (*) or markdown formatting in your responses
- Use simple bullet points with • symbol
- Use clear line breaks for readability
- Keep responses conversational and easy to read

IMPORTANT - INDIA-SPECIFIC INFORMATION:
- Always provide INDIAN helplines, emergency numbers, and resources when relevant
- Use Indian medical terminology and practices
- Reference Indian healthcare system (AIIMS, government hospitals, PHCs, etc.)
- ONLY mention helplines and emergency numbers when the situation is SERIOUS, URGENT, or LIFE-THREATENING

For serious cases, provide relevant Indian helplines:
• Emergency: 112
• Ambulance: 102
• Mental Health Helpline: 08046110007 (NIMHANS)
• Women Helpline: 181
• Child Helpline: 1098
• National Health Helpline: 1800-180-1104'''
            },
            {
              'role': 'user',
              'content': message,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'];
        
        // Remove asterisks and clean up formatting
        content = content.replaceAll('**', '');
        content = content.replaceAll('*', '');
        
        return content;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get online response: $e');
    }
  }


  // Offline keyword-based responses
  String getOfflineResponse(String message, String language) {
    final lowerMessage = message.toLowerCase();
    
    // Greetings
    if (_isGreeting(lowerMessage)) {
      return _getGreeting(language);
    }
    
    // Emergency symptoms
    if (_isEmergency(lowerMessage)) {
      return _getEmergencyResponse(language);
    }
    
    // Common symptoms
    if (lowerMessage.contains('headache') || lowerMessage.contains('सिरदर्द')) {
      return _getHeadacheResponse(language);
    }
    
    if (lowerMessage.contains('fever') || lowerMessage.contains('बुखार')) {
      return _getFeverResponse(language);
    }
    
    if (lowerMessage.contains('cough') || lowerMessage.contains('खांसी')) {
      return _getCoughResponse(language);
    }
    
    // Default response
    return _getDefaultResponse(language);
  }

  bool _isGreeting(String message) {
    final greetings = ['hi', 'hello', 'hey', 'namaste', 'hola'];
    return greetings.any((g) => message.contains(g));
  }

  bool _isEmergency(String message) {
    final emergencyKeywords = [
      'chest pain', 'heart attack', 'can\'t breathe', 
      'difficulty breathing', 'stroke', 'severe bleeding'
    ];
    return emergencyKeywords.any((k) => message.contains(k));
  }

  String _getGreeting(String language) {
    final greetings = {
      'English': 'Hello! 👋 I\'m MediGuide AI, your healthcare companion. How can I help you today?',
      'Hindi': 'नमस्ते! 👋 मैं MediGuide AI हूं, आपका स्वास्थ्य साथी। आज मैं आपकी कैसे मदद कर सकता हूं?',
      'Tamil': 'வணக்கம்! 👋 நான் MediGuide AI, உங்கள் சுகாதார துணை. இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்?',
    };
    return greetings[language] ?? greetings['English']!;
  }

  String _getEmergencyResponse(String language) {
    final responses = {
      'English': '''⚠️ EMERGENCY: Your symptoms may indicate a medical emergency.

Please seek immediate medical care or call 108 now.

Do NOT wait. These symptoms require urgent medical attention.''',
      'Hindi': '''⚠️ आपातकाल: आपके लक्षण एक चिकित्सा आपातकाल का संकेत दे सकते हैं।

कृपया तुरंत चिकित्सा सहायता लें या अभी 108 पर कॉल करें।

प्रतीक्षा न करें। इन लक्षणों के लिए तत्काल चिकित्सा ध्यान की आवश्यकता है।''',
    };
    return responses[language] ?? responses['English']!;
  }


  String _getHeadacheResponse(String language) {
    final responses = {
      'English': '''I understand you're experiencing headache. Let me help you.

**Possible Causes:**
• Tension headache
• Migraine
• Dehydration
• Stress

**Immediate Relief:**
• Rest in a quiet, dark room
• Stay hydrated
• Apply cold compress
• Take paracetamol if needed

**When to See a Doctor:**
• Severe or sudden headache
• Headache with fever
• Vision changes
• Persistent headache

Please consult a doctor for proper diagnosis.''',
      'Hindi': '''मैं समझता हूं कि आपको सिरदर्द हो रहा है। मैं आपकी मदद करता हूं।

**संभावित कारण:**
• तनाव सिरदर्द
• माइग्रेन
• निर्जलीकरण
• तनाव

**तत्काल राहत:**
• शांत, अंधेरे कमरे में आराम करें
• हाइड्रेटेड रहें
• ठंडा सेक लगाएं
• जरूरत पड़ने पर पैरासिटामोल लें

**डॉक्टर से कब मिलें:**
• गंभीर या अचानक सिरदर्द
• बुखार के साथ सिरदर्द
• दृष्टि में परिवर्तन
• लगातार सिरदर्द

कृपया उचित निदान के लिए डॉक्टर से परामर्श करें।''',
    };
    return responses[language] ?? responses['English']!;
  }

  String _getFeverResponse(String language) {
    final responses = {
      'English': '''I understand you have fever. Here's what you can do:

**Immediate Care:**
• Rest and stay hydrated
• Take paracetamol (500mg every 6 hours)
• Use cold compress on forehead
• Wear light clothing

**Monitor:**
• Temperature every 4 hours
• Other symptoms

**See a Doctor if:**
• Fever above 103°F (39.4°C)
• Fever lasting more than 3 days
• Difficulty breathing
• Severe headache

Stay safe and consult a doctor if symptoms worsen.''',
      'Hindi': '''मैं समझता हूं कि आपको बुखार है। यहां बताया गया है कि आप क्या कर सकते हैं:

**तत्काल देखभाल:**
• आराम करें और हाइड्रेटेड रहें
• पैरासिटामोल लें (हर 6 घंटे में 500mg)
• माथे पर ठंडा सेक लगाएं
• हल्के कपड़े पहनें

**निगरानी करें:**
• हर 4 घंटे में तापमान
• अन्य लक्षण

**डॉक्टर से मिलें यदि:**
• 103°F (39.4°C) से ऊपर बुखार
• 3 दिनों से अधिक समय तक बुखार
• सांस लेने में कठिनाई
• गंभीर सिरदर्द

सुरक्षित रहें और यदि लक्षण बिगड़ते हैं तो डॉक्टर से परामर्श करें।''',
    };
    return responses[language] ?? responses['English']!;
  }

  String _getCoughResponse(String language) {
    final responses = {
      'English': '''I understand you have a cough. Here's guidance:

**Home Remedies:**
• Drink warm water with honey
• Steam inhalation
• Gargle with salt water
• Stay hydrated

**Avoid:**
• Cold drinks
• Smoking
• Dusty environments

**See a Doctor if:**
• Cough lasting more than 2 weeks
• Blood in cough
• Difficulty breathing
• High fever

Take care and consult a doctor if needed.''',
      'Hindi': '''मैं समझता हूं कि आपको खांसी है। यहां मार्गदर्शन है:

**घरेलू उपचार:**
• शहद के साथ गर्म पानी पिएं
• भाप लें
• नमक के पानी से गरारे करें
• हाइड्रेटेड रहें

**बचें:**
• ठंडे पेय
• धूम्रपान
• धूल भरे वातावरण

**डॉक्टर से मिलें यदि:**
• 2 सप्ताह से अधिक समय तक खांसी
• खांसी में खून
• सांस लेने में कठिनाई
• तेज बुखार

ध्यान रखें और जरूरत पड़ने पर डॉक्टर से परामर्श करें।''',
    };
    return responses[language] ?? responses['English']!;
  }

  String _getDefaultResponse(String language) {
    final responses = {
      'English': '''I'm here to help with your health concerns. 

You can ask me about:
• Symptoms you're experiencing
• General health advice
• When to see a doctor
• Preventive health tips

Please describe your symptoms or health concern, and I'll do my best to guide you.

Note: I'm currently offline, so I'm providing basic guidance. For detailed advice, please connect to the internet or consult a healthcare professional.''',
      'Hindi': '''मैं आपकी स्वास्थ्य चिंताओं में मदद के लिए यहां हूं।

आप मुझसे पूछ सकते हैं:
• आप जो लक्षण अनुभव कर रहे हैं
• सामान्य स्वास्थ्य सलाह
• डॉक्टर से कब मिलना है
• निवारक स्वास्थ्य सुझाव

कृपया अपने लक्षणों या स्वास्थ्य चिंता का वर्णन करें, और मैं आपका मार्गदर्शन करने की पूरी कोशिश करूंगा।

नोट: मैं वर्तमान में ऑफ़लाइन हूं, इसलिए मैं बुनियादी मार्गदर्शन प्रदान कर रहा हूं। विस्तृत सलाह के लिए, कृपया इंटरनेट से कनेक्ट करें या स्वास्थ्य पेशेवर से परामर्श करें।''',
    };
    return responses[language] ?? responses['English']!;
  }
}
