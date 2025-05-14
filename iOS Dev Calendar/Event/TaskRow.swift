import SwiftUI

struct TaskRow: View {
    let title: String
    let subtitle: String
    let type: CardType
    var customColor: String? = nil

    // Add unique ID for UserDefaults
    private var taskId: String {
        "\(title)_\(subtitle)".replacingOccurrences(of: " ", with: "_")
    }

    @State private var isCompleted: Bool = false

    // For calendar entries
    init(entry: CalendarDateModel) {
        self.title = entry.topic
        self.subtitle = entry.label
        self.type = .lesson
        self.customColor = nil
        _isCompleted = State(initialValue: UserDefaults.standard.bool(forKey: "\(entry.topic)_\(entry.label)"))
    }

    // For card-style entries
    init(title: String, subtitle: String, type: CardType, color: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.customColor = color
        _isCompleted = State(initialValue: UserDefaults.standard.bool(forKey: "\(title)_\(subtitle)"))
    }

    enum CardType {
        case lesson, goal, word, review, dueHomework, dueReading, codeChallenge

        var backgroundColor: Color {
            switch self {
            case .lesson: return Color(red: 0.43, green: 0.11, blue: 0.14)
            case .goal: return Color(red: 0.95, green: 0.79, blue: 0.41)
            case .word: return Color(red: 0.17, green: 0.18, blue: 0.26)
            case .review: return Color(red: 0.55, green: 0.55, blue: 0.54)
            case .dueHomework: return Color(red: 0.84, green: 0.62, blue: 0.60)
            case .dueReading: return Color(red: 0.95, green: 0.84, blue: 0.84)
            case .codeChallenge: return Color(red: 0.30, green: 0.42, blue: 0.31)
            }
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Only show checkbox for tasks that make sense to check off
            if type != .lesson && type != .word {
                Toggle("", isOn: $isCompleted)
                    .toggleStyle(CheckboxStyle())
                    .onChange(of: isCompleted) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: taskId)
                    }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(customColor.map { Color($0) } ?? type.backgroundColor)
                .opacity(0.15)
        )
    }
}

// Custom checkbox style
struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .imageScale(.large)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
