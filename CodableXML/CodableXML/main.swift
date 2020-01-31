import Foundation
import XMLCoder

let xml = """
<movie title="Rise of Skywalker" releaseYear="2019">
    <category>Sci-fi</category>
    <actors>
        <actor name="Daisy Ridley" />
        <actor name="John Boyega" />
    </actors>
    <director name="JJ Abrams" />
</movie>
"""

struct Movie : Codable, DynamicNodeEncoding {
    let title: String
    let category: String
    let releaseYear: Int
    let director: Person
    let actors: NestedArray<Person, ActorsKeyProvider>

    struct ActorsKeyProvider : KeyProvider {
        static var key = "actor"
    }

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case Movie.CodingKeys.title, Movie.CodingKeys.releaseYear: return .attribute
        default: return .element
        }
    }
}

struct Person : Codable, DynamicNodeEncoding {
    let name: String

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}


let data = xml.data(using: .utf8)!
do {

    let decoder = XMLDecoder()
    let movie = try decoder.decode(Movie.self, from: data)
    print(movie)

    let winner = movie.actors.value.randomElement()!
    print("The oscar winner is: \(winner.name)")


    let encoder = XMLEncoder()
    encoder.outputFormatting = .prettyPrinted
    let encodedData = try encoder.encode(movie, withRootKey: "movie")
    print(String(data: encodedData, encoding: .utf8)!)

} catch {
    print("Error: \(error)")
}
