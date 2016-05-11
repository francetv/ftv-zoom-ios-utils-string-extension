/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 France Télévisions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 * to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of
 * the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 * THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import UIKit
import XCTest

class StringCommonTests: XCTestCase {

    func testReplace() {
        XCTAssertEqual("abcAbc".replace("abc", withString: "def"), "defAbc")
        XCTAssertEqual("abcAbc".replace("cA", withString: "TOTO"), "abTOTObc")
        XCTAssertEqual("abcAbc".replace("ABC", withString: "DEF"), "abcAbc")
        XCTAssertEqual("abcAbc".replace("", withString: "def"), "abcAbc")
    }
    
    func testIndexOf_nominals() {
        XCTAssertEqual("abcabc".indexOf("b"), 1)
        XCTAssertEqual("abcAbc".indexOf("a"), 0)
        XCTAssertEqual("AbcAbc".indexOf("A"), 0)
    }

    func testIndexOf_limits() {
        XCTAssertNil("AbcAbc".indexOf("B"))
        XCTAssertNil("AbcAbc".indexOf("d"))
    }

    func testLastIndexOf_nominals() {
        XCTAssertEqual("abcabc".lastIndexOf("c"), 5)
        XCTAssertEqual("abcAbc".lastIndexOf("a"), 0)
        XCTAssertEqual("AbcAbc".lastIndexOf("A"), 3)
    }
    
    func testLastIndexOf_limits() {
        XCTAssertNil("AbcAbc".lastIndexOf("B"))
        XCTAssertNil("AbcAbc".lastIndexOf("d"))
    }

    func testSubstring_nominal_with_length() {
        XCTAssertEqual("abc-1-2-3".substring(0, length: 3), "abc")
        XCTAssertEqual("abc-1-2-3".substring(0, length: 2), "ab")
        XCTAssertEqual("abc-1-2-3".substring(1, length: 2), "bc")
        XCTAssertEqual("abc-1-2-3".substring(1, length: 1), "b")
    }

    func testSubstring_nominal_without_length() {
        XCTAssertEqual("abc-1-2-3".substring(0), "abc-1-2-3")
        XCTAssertEqual("abc-1-2-3".substring(1), "bc-1-2-3")
        XCTAssertEqual("abc-1-2-3".substring(4), "1-2-3")
    }

    func testStartsWith() {
        XCTAssertTrue("abcDEF".startsWith("abc"))
        XCTAssertTrue("abcDEF".startsWith("a"))
        XCTAssertTrue("abcDEF".startsWith("abcD"))
        XCTAssertTrue("abcDEF".startsWith("abcDEF"))
        XCTAssertFalse("abcDEF".startsWith("AB"))
        XCTAssertFalse("abcDEF".startsWith("bc"))
        XCTAssertFalse("abcDEF".startsWith(""))
        XCTAssertFalse("abcDEF".startsWith("abcDEFghi"))
    }

    func testEndsWith() {
        XCTAssertTrue("abcDEF".endsWith("DEF"))
        XCTAssertTrue("abcDEF".endsWith("F"))
        XCTAssertTrue("abcDEF".endsWith("cDEF"))
        XCTAssertTrue("abcDEF".endsWith("abcDEF"))
        XCTAssertFalse("abcDEF".endsWith("ef"))
        XCTAssertFalse("abcDEF".endsWith("cD"))
        XCTAssertFalse("abcDEF".endsWith(""))
        XCTAssertFalse("abcDEF".startsWith("abcDEFghi"))
    }

    func testSlugify_identity() {
        // When
        let actual = "abc-1-2-3".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("abc-1-2-3", actual!, "Sut and slug should be equal")
    }
    
    func testSlugify_accented_chars() {
        // When
        let actual = "āčēģīķļņūö".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("acegiklnuo", actual!, "Slug did not work !")
    }
    
    func testSlugify_uppercase_and_accented_chars() {
        // When
        let actual = "ÉÀÈTESTÂÄÔÖ".slugify()
    
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("eaetestaaoo", actual!, "Slug did not work !")
    }
    
    func testSlugify_special_chars_outside() {
        // When
        let actual = "?;::test++-__!!".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test", actual!, "Slug did not work !")
    }
    
    func testSlugify_special_chars_inside() {
        // When
        let actual = "nice ?;::te§st++-__!!".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("nice-te-st", actual!, "Slug did not work !")
    }
    
    func testSlugify_leading_and_trailing_separator() {
        // When
        let actual = "----test------".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test", actual!, "Slug did not work !")
    }
    
    func testSlugify_chinese_chars() {
        // When
        let actual = "chinese 中文測試 text".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("chinese-text", actual!, "Slug did not work !")
    }
    
    func testSlugify_stripped_character_then_whitespace() {
        // When
        let actual = "( test !".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test", actual!, "Slug did not work !")
    }
    
    func testSlugify_whitespace_inside() {
        // When
        let actual = "test tip top".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test-tip-top", actual, "Slug did not work !")
    }
    
    func testSlugify_surrounding_whitespace() {
        // When
        let actual = " testtiptop ".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("testtiptop", actual, "Slug did not work !")
    }
    
    func testSlugify_excessive_whitespace() {
        // When
        let actual = " test   \n tip   \t top ".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test-tip-top", actual, "Slug did not work !")
    }
    
    func testSlugify_separators_inside() {
        // When
        let actual = "test ---- tip - top ".slugify()
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test-tip-top", actual, "Slug did not work !")
    }
    
    func testSlugify_identity_empty_separator() {
        // When
        let actual = "abc-1-2-3".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("abc123", actual, "Sut and slug should be equal")
    }
    
    func testSlugify_accented_chars_empty_seperator() {
        // When
        let actual = "āčēģīķļņūö".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("acegiklnuo", actual, "Slug did not work !")
    }
    
    func testSlugify_uppercase_empty_seperator() {
        // When
        let actual = "ÉÀÈTESTÂÄÔÖ".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("eaetestaaoo", actual, "Slug did not work !")
    }
    
    func testSlugify_special_chars_outside_empty_separator() {
        // When
        let actual = "?;::test++-__!!".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test", actual, "Slug did not work !")
    }
    
    func testSlugify_special_chars_inside_empty_separator() {
        // When
        let actual = "nice ?;::te§st++-__!!".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("nicetest", actual, "Slug did not work !")
    }
    
    func testSlugify_leading_and_trailing_default_separator_empty_separator() {
        // When
        let actual = "----test------".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test", actual, "Slug did not work !")
    }
    
    func testSlugify_chinese_chars_empty_separator() {
        // When
        let actual = "chinese 中文測試 text".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("chinesetext", actual, "Slug did not work !")
    }
    
    func testSlugify_stripped_character_then_whitespace_empty_separator() {
        // When
        let actual = "( test !".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("test", actual, "Slug did not work !")
    }
    
    func testSlugify_whitespace_inside_empty_separator() {
        // When
        let actual = "test tip top".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("testtiptop", actual, "Slug did not work !")
    }
    
    func testSlugify_surrounding_whitespace_empty_separator() {
        // When
        let actual = " test tip top ".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("testtiptop", actual, "Slug did not work !")
    }
    
    func testSlugify_excessive_whitespace_empty_separator() {
        // When
        let actual = " test   \n tip   \t top ".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("testtiptop", actual, "Slug did not work !")
    }
    
    func testSlugify_squeeze_separators_empty_separator() {
        // When
        let actual = "test ---- tip - top ".slugify(separator: "")
        
        // Then
        XCTAssertNotNil(actual, "Slug should not be nil")
        XCTAssertEqual("testtiptop", actual, "Slug did not work !")
    }
}