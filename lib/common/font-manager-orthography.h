/* font-manager-orthography.h
 *
 * Copyright (C) 2009 - 2018 Jerry Casiano
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.
 *
 * If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.
*/

#ifndef __ORTHOGRAPHY_DATA_H__
#define __ORTHOGRAPHY_DATA_H__

#include <glib.h>
#include <json-glib/json-glib.h>

#define START_RANGE_PAIR 0x0002
#define END_OF_DATA 0x0000

typedef struct
{
    const gchar *name;
    const gchar *native;
    const gunichar key;
    const gchar *sample;
    const gchar *pangram [10];
    const gunichar values [4096];
}
OrthographyData;

/* Contains entries added manually */
static const struct
{
    const gchar *name;
    const gchar *native;
}
Orthographies [] =
{
    { "Afrikaans", "Afrikaans" },
    { "Ahom", "Ahom" },
    { "Aleut Cyrillic", "Aleut Cyrillic" },
    { "Aleut Latin", "Unangan" },
    { "Arabic", "العربية" },
    { "Archaic Greek Letters", "Archaic Greek Letters" },
    { "Armenian", "Հայերեն" },
    { "Astronomy", "Astronomy" },
    { "Balinese", "Balinese" },
    { "Baltic", "Baltic" },
    { "Bamum", "ꚠꚡꚢꚣ" },
    { "Basic Cyrillic", "Кири́ллица" },
    { "Basic Greek", "Ελληνικό αλφάβητο" },
    { "Basic Latin", "Basic Latin" },
    { "Surat Batak", "Surat Batak" },
    { "Bengali", "বাংলা" },
    { "Brāhmī", "Brāhmī" },
    { "Buginese", "Buginese" },
    { "Unified Canadian Aboriginal Syllabics", "Unified Canadian Aboriginal Syllabics" },
    { "Carian", "Carian" },
    { "Catalan", "Català" },
    { "Central European", "Central European" },
    { "Chakma", "Chakma" },
    { "Cham", "Cham" },
    { "Cherokee", "ᏣᎳᎩ" },
    { "Chess Symbols", "Chess Symbols" },

    /* CJK entries added manually */
    { "CJK Unified", "CJK Unified" },
    { "CJK Unified Extension A", "CJK Unified Extension A" },
    { "CJK Unified Extension B", "CJK Unified Extension B" },
    { "CJK Unified Extension C", "CJK Unified Extension C" },
    { "CJK Unified Extension D", "CJK Unified Extension D" },
    { "CJK Unified Extension E", "CJK Unified Extension E" },
    { "CJK Compatibility Ideographs", "CJK Compatibility Ideographs" },
    { "CJK Compatibility Ideographs Supplement", "CJK Compatibility Ideographs Supplement" },
    /* End CJK entries */

    { "Claudian Letters", "Claudian Letters" },
    { "Coptic", "Ⲙⲉⲧⲣⲉⲙ̀ⲛⲭⲏⲙⲓ" },
    { "Currencies", "Currencies" },
    { "Cypriot Syllabary", "Cypriot Syllabary" },
    { "Devanagari", "देवनागरी" },
    { "Dutch", "Nederlands" },
    { "Egyptian Hieroglyphs", "Egyptian Hieroglyphs" },
    { "Emoticons", "Emoticons" },
    { "Ethiopic", "ግዕዝ" },

    /* This "orthography" contains only the euro symbol... */
    //{ "Euro", "Euro" },

    { "Farsi", "فارسی" },
    { "Food and Drink", "Food and Drink" },
    { "Georgian", "ქართული დამწერლობა" },
    { "Glagolitic", "hlaholika" },
    { "Gothic", "𐌲𐌿𐍄𐌹𐍃𐌺" },
    { "Gujarati", "ગુજરાતી લિપિ" },
    { "Gurmukhi", "ਗੁਰਮੁਖੀ" },
    { "Korean Hangul", "한글 / 조선글" },
    { "Hanunó'o", "Hanunó'o" },
    { "Hebrew", "עִבְרִית" },
    { "IPA", "aɪ pʰiː eɪ" },
    { "Igbo Onwu", "Asụsụ Igbo" },
    { "IPA", "aɪ pʰiː eɪ" },
    { "Korean Jamo", "자모" },
    { "Javanese", "Javanese" },
    { "Japanese Jinmeiyo", "日本人名用漢字" },
    { "Japanese Joyo", "日本常用漢字" },
    { "Kaithi", "Kaithi" },
    { "Japanese Kana", "仮名" },
    { "Kannada", "ಕನ್ನಡ" },
    { "Kayah Li", "Kayah Li" },
    { "Kazakh", "قازاق" },
    { "Kharoshthi", "Kharoshthi" },
    { "Khmer", "អក្សរខ្មែរ" },
    { "Japanese Kokuji", "日本国字 (和制汉字)" },
    { "Lao", "ພາສາລາວ" },
    { "Latin Ligatures", "Latin Ligatures" },
    { "Lepcha", "Lepcha" },
    { "Limbu", "Limbu" },
    { "Linear B Ideograms", "Linear B Ideograms" },
    { "Linear B Syllabary", "Linear B Syllabary" },
    { "Malayalam", "മലയാളം" },
    { "Mathematical Greek", "Mathematical Greek" },
    { "Mathematical Latin", "Mathematical Latin" },
    { "Mathematical Numerals", "Mathematical Numerals" },
    { "Mathematical Operators", "Mathematical Operators" },
    { "Meetei Mayak", "Meetei Mayak" },
    { "Mende Kikakui", "Mende Kikakui" },
    { "MeroiticCursive", "MeroiticCursive" },
    { "Meroitic Hieroglyphs", "Meroitic Hieroglyphs" },
    { "Miao", "Miao" },
    { "Mongolian", "Mongolian" },

    /* Medieval Unicode Font Initiative - http://folk.uib.no/hnooh/mufi/
     * Contains lots of duplicates, doubt many would find it useful
     */
    //{ "MUFI 3.0", "MUFI 3.0" },

    { "Myanmar", "မြန်မာအက္ခရာ" },
    { "New Tai Lue", "New Tai Lue" },
    { "N’Ko", "ߒߞߏ" },
    { "Ogham", "Ogham" },
    { "Ol Chiki", "Ol Chiki" },
    { "Old Italic", "Old Italic" },
    { "Old South Arabian", "Old South Arabian" },
    { "Oriya", "ଓଡ଼ିଆ" },
    { "Osmanya", "𐒋𐒘𐒈𐒑𐒛𐒒𐒕𐒀" },
    { "Pan African Latin", "Pan African Latin" },
    { "Pashto", "پښتو" },
    { "Phags Pa", "Phags Pa" },
    { "Pinyin", "汉语拼音" },
    { "Polynesian", "Polynesian" },
    { "Polytonic Greek", "Polytonic Greek" },
    { "Rejang", "Rejang" },
    { "Romanian", "Română" },
    { "Runic", "ᚠᚢᚦᛆᚱᚴ" },
    { "Saurashtra", "Saurashtra" },
    { "Simplified Chinese", "中文简体字" },
    { "Sindhi", "سنڌي" },
    { "Sinhala", "සිංහල" },
    { "South Korean Hanja", "한문교육용기초한자" },
    { "Sundanese", "Sundanese" },
    { "Syloti Nagri", "Syloti Nagri" },
    { "Syriac", "ܠܫܢܐ ܣܘܪܝܝܐ" },
    { "Tai Le", "Tai Le" },
    { "Tai Tham (Lanna)", "ᨲᩫ᩠ᩅᨾᩮᩥᩬᨦ" },
    { "Tai Viet", "Tai Viet" },
    { "Tamil", "தமிழ் அரிச்சுவடி " },
    { "Telugu", "తెలుగు" },
    { "Thaana", "ތާނަ" },
    { "Thai", "ภาษาไทย" },
    { "Tibetan", "དབུ་ཅན་" },
    { "Tifinagh", "ⵜⵉⴼⵉⵏⴰⵖ" },
    { "Traditional Chinese", "中文正體字" },
    { "Turkish", "Türkçe" },
    { "Uighur", "ئۇيغۇر" },
    { "Urdu", "اُردو" },
    { "Vai", "Vai" },
    { "Vedic Extensions", "Vedic Extensions" },
    { "Venda", "Tshivenḓa" },
    { "Vietnamese", "tiếng Việt" },
    { "Western European", "Western European" },
    { "Yi", "ꆈꌠꁱꂷ" },
    { "Chinese Zhuyin Fuhao", "注音符號" },
};

static const OrthographyData ArabicOrthographies [] = {
#include "Arabic"
#include "Farsi"
#include "Urdu"
#include "Kazakh"
#include "Pashto"
#include "Sindhi"
#include "Uighur"
};

static const OrthographyData ChineseOrthographies [] = {
#include "SimplifiedChinese"
#include "TraditionalChinese"
#include "ZhuYinFuHao"
#include "CJKUnified"
};

static const OrthographyData GreekOrthographies [] = {
#include "BasicGreek"
#include "PolytonicGreek"
#include "ArchaicGreekLetters"
};

static const OrthographyData JapaneseOrthographies [] = {
#include "Kana"
#include "Joyo"
#include "Jinmeiyo"
#include "Kokuji"
};

static const OrthographyData KoreanOrthographies [] = {
#include "Jamo"
#include "Hangul"
#include "SouthKoreanHanja"
};

static const OrthographyData LatinOrthographies [] = {
#include "BasicLatin"
#include "WesternEuropean"
// Only contains one symbol
//#include "Euro"
#include "Catalan"
#include "Baltic"
#include "Turkish"
#include "CentralEuropean"
#include "Romanian"
#include "Vietnamese"
#include "PanAfricanLatin"
#include "Dutch"
#include "Afrikaans"
#include "Pinyin"
#include "IPA"
#include "LatinLigatures"
#include "ClaudianLetters"
#include "Venda"
#include "IgboOnwu"
};

static const OrthographyData UncategorizedOrthographies [] = {

//
// The Rest: (In Latin alphabetic order for now ... )
//
#include "Ahom"
#include "AleutCyrillic"
#include "AleutLatin"
#include "Armenian"
#include "Astronomy"
#include "BasicCyrillic"
#include "CanadianSyllabics"
#include "Carian"
#include "Chakma"
#include "Cherokee"
#include "Coptic"
#include "Currencies"
#include "Food"
#include "Georgian"
#include "Hebrew"
#include "Khmer"
#include "Lao"
#include "MendeKikakui"
#include "Miao"
// Not very useful?
//#include "MUFI"
#include "Myanmar"
#include "Ogham"
#include "Polynesian"
#include "Runic"
#include "Syriac"
#include "Thaana"
#include "Thai"
#include "Tibetan"
#include "Yi"

//
// Symbols -- Divide Unicode blocks
// into meaningful groups such as "chess symbols"
// as necessary.
//
#include "MathematicalGreek"
#include "MathematicalLatin"
#include "MathematicalNumerals"
#include "MathematicalOperators"
#include "ChessSymbols"
#include "Emoticons"

//
// Indic:
//
#include "Bengali"
#include "Devanagari"
#include "Kannada"
#include "Tamil"
#include "Sinhala"
#include "Telugu"
#include "Malayalam"
#include "Gujarati"
#include "Gurmukhi"
#include "Oriya"
#include "Kaithi"
#include "Kharoshthi"
#include "Lepcha"
#include "Limbu"
#include "MeeteiMayak"
#include "OlChiki"
#include "Saurashtra"
#include "SylotiNagri"
#include "VedicExtensions"

//
// Philippine scripts
//
#include "Hanunoo"

//
// African scripts
//
#include "Nko"
#include "Osmanya"
#include "Tifinagh"
#include "Vai"
#include "Ethiopic"

// 2009.08.27.ET Additions:
#include "TaiLe"
#include "NewTaiLue"
#include "PhagsPa"
#include "Mongolian"
#include "TaiTham"

// 2011.04.19,20.ET Addenda:
#include "Glagolitic"
#include "Gothic"
#include "Bamum"
#include "Brahmi"

#include "Batak"
#include "Balinese"
#include "Buginese"
#include "Cham"
#include "Javanese"
#include "KayahLi"

#include "Rejang"
#include "Sundanese"
#include "TaiViet"

//////////////////////
//
// Historic:
//
//////////////////////
#include "OldSouthArabian"
#include "LinearBIdeograms"
#include "LinearBSyllabary"
#include "CypriotSyllabary"
#include "MeroiticHieroglyphs"
#include "MeroiticCursive"
#include "EgyptianHieroglyphs"

};

#define N_ORTHOGRAPHIES G_N_ELEMENTS(Orthographies)
#define N_ARABIC G_N_ELEMENTS(ArabicOrthographies)
#define N_CHINESE G_N_ELEMENTS(ChineseOrthographies)
#define N_GREEK G_N_ELEMENTS(GreekOrthographies)
#define N_JAPANESE G_N_ELEMENTS(JapaneseOrthographies)
#define N_KOREAN G_N_ELEMENTS(KoreanOrthographies)
#define N_LATIN G_N_ELEMENTS(LatinOrthographies)
#define N_MISC G_N_ELEMENTS(UncategorizedOrthographies)

JsonObject * font_manager_get_orthography_results (JsonObject *font);
gchar * font_manager_get_sample_string_for_orthography (JsonObject *orthography, GList *charset);

#endif /* __ORTHOGRAPHY_DATA_H__ */

