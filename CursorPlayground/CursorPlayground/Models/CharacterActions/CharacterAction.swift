import Foundation

protocol CharacterAction {
    func execute(character: Character) -> ActionResult
}
