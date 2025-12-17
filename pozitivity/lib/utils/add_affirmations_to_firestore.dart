import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> addAffirmationsToFirestore() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Map<String, String>> affirmations = [
    // Kendine Güven
    {"category": "Kendine Güven", "text": "Kendime inanıyor ve güveniyorum."},
    {"category": "Kendine Güven", "text": "Değerli ve yeterliyim."},
    {"category": "Kendine Güven", "text": "Hatalarımdan ders alıyorum ve büyüyorum."},
    {"category": "Kendine Güven", "text": "Gücüm içimde, onu her an hissediyorum."},
    {"category": "Kendine Güven", "text": "Kendimi olduğum gibi kabul ediyorum."},
    {"category": "Kendine Güven", "text": "İçimdeki potansiyeli fark ediyorum."},
    {"category": "Kendine Güven", "text": "Kendi kararlarıma güveniyorum."},
    {"category": "Kendine Güven", "text": "Kendi yolumu cesurca seçiyorum."},
    {"category": "Kendine Güven", "text": "Olumlu düşüncelerim beni güçlendiriyor."},
    {"category": "Kendine Güven", "text": "Kendime karşı nazik ve sabırlıyım."},

    // Başarı ve Kariyer
    {"category": "Başarı ve Kariyer", "text": "Her gün hedeflerime bir adım daha yaklaşıyorum."},
    {"category": "Başarı ve Kariyer", "text": "Başarıya ulaşmak benim doğal hakkım."},
    {"category": "Başarı ve Kariyer", "text": "Yeni fırsatlar beni buluyor."},
    {"category": "Başarı ve Kariyer", "text": "Çalışmam takdir ediliyor ve karşılığını alıyorum."},
    {"category": "Başarı ve Kariyer", "text": "Zorluklar beni daha güçlü yapıyor."},
    {"category": "Başarı ve Kariyer", "text": "Kararlılığım hedeflerime ulaşmamı sağlıyor."},
    {"category": "Başarı ve Kariyer", "text": "Yaratıcılığım başarıya katkıda bulunuyor."},
    {"category": "Başarı ve Kariyer", "text": "Her gün öğreniyor ve gelişiyorum."},
    {"category": "Başarı ve Kariyer", "text": "İşimde ve hayatımda mükemmeliyet için çalışıyorum."},
    {"category": "Başarı ve Kariyer", "text": "Başarı benim motivasyon kaynağımdır."},

    // Huzur ve Rahatlama
    {"category": "Huzur ve Rahatlama", "text": "Şu an güvendeyim ve huzurluyum."},
    {"category": "Huzur ve Rahatlama", "text": "Derin bir nefes alıyor ve rahatlıyorum."},
    {"category": "Huzur ve Rahatlama", "text": "Zihnimi sakinleştiriyor, bedenimi dinlendiriyorum."},
    {"category": "Huzur ve Rahatlama", "text": "Hayatın akışına güveniyorum."},
    {"category": "Huzur ve Rahatlama", "text": "Dinginlik ve huzur içimde."},
    {"category": "Huzur ve Rahatlama", "text": "Stresi serbest bırakıyorum ve rahatlıyorum."},
    {"category": "Huzur ve Rahatlama", "text": "Kendime zaman ayırıyorum ve huzuru hissediyorum."},
    {"category": "Huzur ve Rahatlama", "text": "Sakinlik ve huzur her nefeste benimle."},
    {"category": "Huzur ve Rahatlama", "text": "Düşüncelerim sessiz ve net."},
    {"category": "Huzur ve Rahatlama", "text": "Ruhum huzur içinde ve dengede."},

    // Aşk & İlişkiler
    {"category": "Aşk & İlişkiler", "text": "Sevgi dolu ilişkiler hayatımda yer alıyor."},
    {"category": "Aşk & İlişkiler", "text": "Kendi değerimi bilerek sevgi paylaşıyorum."},
    {"category": "Aşk & İlişkiler", "text": "Kalbim açık ve sevgiye hazır."},
    {"category": "Aşk & İlişkiler", "text": "İlişkilerimde saygı ve anlayış hakim."},
    {"category": "Aşk & İlişkiler", "text": "Sevgi kendiliğinden hayatıma akıyor."},
    {"category": "Aşk & İlişkiler", "text": "Sevdiklerimle uyum ve mutluluk paylaşıyorum."},
    {"category": "Aşk & İlişkiler", "text": "İçten ve samimi bağlar kuruyorum."},
    {"category": "Aşk & İlişkiler", "text": "Sevgi enerjisi her yerde benimle."},
    {"category": "Aşk & İlişkiler", "text": "İlişkilerimde güven ve huzur var."},
    {"category": "Aşk & İlişkiler", "text": "Kalbim ve ruhum sevgiyle dolu."},

    // Sağlık ve Zindelik
    {"category": "Sağlık ve Zindelik", "text": "Sağlığım her geçen gün güçleniyor."},
    {"category": "Sağlık ve Zindelik", "text": "Vücudum dengeli ve enerjik."},
    {"category": "Sağlık ve Zindelik", "text": "Zihnim ve bedenim uyum içinde."},
    {"category": "Sağlık ve Zindelik", "text": "Enerjim taze ve yenilenmiş."},
    {"category": "Sağlık ve Zindelik", "text": "Her gün sağlıklı seçimler yapıyorum."},
    {"category": "Sağlık ve Zindelik", "text": "Bedenim bana şükrediyor ve destek oluyor."},
    {"category": "Sağlık ve Zindelik", "text": "Kendimi güçlü ve sağlıklı hissediyorum."},
    {"category": "Sağlık ve Zindelik", "text": "Hareket ve beslenme ile kendimi destekliyorum."},
    {"category": "Sağlık ve Zindelik", "text": "Ruhum ve bedenim dengede."},
    {"category": "Sağlık ve Zindelik", "text": "Her gün enerjim yükseliyor."},

    // Yaratıcılık ve İlham
    {"category": "Yaratıcılık ve İlham", "text": "Yaratıcılığım her gün gelişiyor."},
    {"category": "Yaratıcılık ve İlham", "text": "İlham her an bana akıyor."},
    {"category": "Yaratıcılık ve İlham", "text": "Yeni fikirler bulmak benim doğal yeteneğim."},
    {"category": "Yaratıcılık ve İlham", "text": "Hayal gücümü özgürce kullanıyorum."},
    {"category": "Yaratıcılık ve İlham", "text": "Yaratıcı çözümler hayatımda yer buluyor."},
    {"category": "Yaratıcılık ve İlham", "text": "Fikirlerim değerli ve anlamlı."},
    {"category": "Yaratıcılık ve İlham", "text": "İlham dolu anlar beni motive ediyor."},
    {"category": "Yaratıcılık ve İlham", "text": "Yaratıcılık beni ifade etme biçimimdir."},
    {"category": "Yaratıcılık ve İlham", "text": "Her gün yeni şeyler keşfediyorum."},
    {"category": "Yaratıcılık ve İlham", "text": "Hayal gücüm ve yeteneklerim uyum içinde."},
  ];

  for (var i = 0; i < affirmations.length; i++) {
    final docId = "aff_${(i + 1).toString().padLeft(3, '0')}";
    await firestore.collection("affirmations").doc(docId).set(affirmations[i]);
    print("Eklenen belge: $docId -> ${affirmations[i]['category']}");
  }

  print("Tüm olumlamalar Firestore'a başarıyla eklendi!");
}
