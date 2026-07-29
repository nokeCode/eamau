#!/bin/bash
# ============================================================================
# SCRIPT D'INTÉGRATION DU MODULE AUTHENTIFICATION
# ============================================================================
# Exécutez ce script pour configurer complètement le module d'authentification
# ============================================================================

echo "🚀 Intégration du module d'authentification EAMAU..."
echo ""

# 1. Nettoyer le cache Flutter
echo "📦 Étape 1: Nettoyage du cache Flutter..."
flutter clean
flutter pub get

# 2. Vérifier la compilation
echo ""
echo "🔍 Étape 2: Vérification de la compilation..."
flutter analyze

# 3. Générer les fichiers si nécessaire
echo ""
echo "⚙️  Étape 3: Génération des fichiers..."
flutter pub run build_runner build --delete-conflicting-outputs 2>/dev/null || true

# 4. Tester la compilation
echo ""
echo "🧪 Étape 4: Test de compilation..."
flutter pub get

echo ""
echo "✅ Installation complète ! "
echo ""
echo "============================================================================"
echo "CONFIGURATION REQUISE"
echo "============================================================================"
echo ""
echo "1. ✏️  METTRE À JOUR L'URL API"
echo "   Fichier: lib/core/api/api_endpoints.dart"
echo "   - Changez 'http://api.eamau.local/api/v1' par votre URL API réelle"
echo ""
echo "2. 🔐 VÉRIFIER ANDROID MANIFEST"
echo "   Fichier: android/app/src/AndroidManifest.xml"
echo "   - Assurez-vous que android.permission.INTERNET est présent"
echo ""
echo "3. 📱 TESTER L'APP"
echo "   flutter run"
echo ""
echo "============================================================================"
echo "PROCHAINES ÉTAPES"
echo "============================================================================"
echo ""
echo "1. Redémarrez votre IDE (VS Code, Android Studio, etc.)"
echo "2. Exécutez: flutter clean && flutter pub get"
echo "3. Testez avec: flutter run"
echo ""

