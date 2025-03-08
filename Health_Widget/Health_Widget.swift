import WidgetKit
import SwiftUI

// Provider handles data loading and timeline management for the widget
struct Provider: TimelineProvider {
    let metricDataService = MetricDataService()
    
    func placeholder(in context: Context) -> HealthEntry {
        HealthEntry(date: Date(), metricData: metricDataService.getMetricData())
    }

    func getSnapshot(in context: Context, completion: @escaping (HealthEntry) -> ()) {
        let entry = HealthEntry(date: Date(), metricData: metricDataService.getMetricData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HealthEntry>) -> ()) {
        let metricData = metricDataService.getMetricData()
        let entry = HealthEntry(date: Date(), metricData: metricData)
        
        // Refresh widget data every hour
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        
        completion(timeline)
    }
}

// Entry model that holds the data for our widget
struct HealthEntry: TimelineEntry {
    let date: Date
    let metricData: HealthMetricData
}

// Reusable circular progress view for displaying health metrics
struct CircularProgressView: View {
    let percentage: Double
    let label: String
    let color: Color
    let targetRange: (Double, Double)?
    
    var body: some View {
        ZStack {
            // Background and shadow
            Circle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Background track
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                .padding(10)
            
            // Target zone indicator (if available)
            if let targetRange = targetRange {
                Circle()
                    .trim(from: targetRange.0 / 100, to: targetRange.1 / 100)
                    .stroke(color.opacity(0.3), lineWidth: 8)
                    .rotationEffect(.degrees(-90))
                    .padding(10)
            }
            
            // Progress arc
            Circle()
                .trim(from: 0, to: percentage / 100)
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(10)
            
            // Inner white circle for text background
            Circle()
                .fill(Color.white)
                .padding(20)
            
            // Percentage and label text
            VStack(spacing: 2) {
                Text("\(Int(percentage))%")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .tracking(0.4)
                    .multilineTextAlignment(.center)
                
                Text(label)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.545, green: 0.549, blue: 0.561))
                    .lineLimit(1)
                    .tracking(0.22)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 55)
        }
        .frame(width: 93, height: 93)
    }
}

// Status indicator showing whether a metric is higher or lower than normal
struct StatusIndicatorView: View {
    let isHigher: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(isHigher ? Color.blue.opacity(0.1) : Color.orange.opacity(0.1))
                .frame(width: 10, height: 10)
            
            Image(systemName: isHigher ? "triangle.fill" : "triangle.fill")
                .font(.system(size: 5))
                .foregroundColor(isHigher ? Color.blue : Color.orange)
                .rotationEffect(isHigher ? .zero : .degrees(180))
        }
    }
}

// Reusable row for displaying metric title, value and status
struct MetricRowView: View {
    let title: String
    let value: String
    let isHigher: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                StatusIndicatorView(isHigher: isHigher)
            }
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .frame(height: 18)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
        }
        .frame(width: 65, height: 33)
    }
}

// Widget view for displaying strain metrics
struct StrainWidgetView: View {
    let data: HealthMetricData
    
    private func formatDuration(minutes: Double) -> String {
        let hours = Int(minutes) / 60
        let mins = Int(minutes) % 60
        return "\(hours)h \(mins)m"
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 16) {
                CircularProgressView(
                    percentage: data.strainScore,
                    label: "strain",
                    color: .orange,
                    targetRange: data.strainTargetRange
                )
                .padding(.top, 12)
                
                HStack(alignment: .top, spacing: 10) {
                    MetricRowView(
                        title: "Duration",
                        value: formatDuration(minutes: data.exerciseMinutes.value),
                        isHigher: data.exerciseMinutes.status == .higherThanNormal
                    )
                    
                    MetricRowView(
                        title: "Calories",
                        value: "\(Int(data.caloriesBurned.value)) kcal",
                        isHigher: data.caloriesBurned.status == .higherThanNormal
                    )
                }
                .frame(height: 33)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(21)
    }
}

// Widget view for displaying recovery metrics
struct RecoveryWidgetView: View {
    let data: HealthMetricData
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 16) {
                CircularProgressView(
                    percentage: data.recoveryScore,
                    label: "recovered",
                    color: .green,
                    targetRange: nil
                )
                .padding(.top, 12)
                
                HStack(alignment: .top, spacing: 10) {
                    MetricRowView(
                        title: "HRV",
                        value: "\(Int(data.heartRateVariability.value)) ms",
                        isHigher: data.heartRateVariability.status == .higherThanNormal
                    )
                    
                    MetricRowView(
                        title: "RHR",
                        value: "\(Int(data.restingHeartRate.value)) bpm",
                        isHigher: data.restingHeartRate.status == .higherThanNormal
                    )
                }
                .frame(height: 33)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(21)
    }
}

// Widget view for displaying sleep metrics
struct SleepWidgetView: View {
    let data: HealthMetricData
    
    private func formatDuration(minutes: Double) -> String {
        let hours = Int(minutes) / 60
        let mins = Int(minutes) % 60
        return "\(hours)h \(mins)m"
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 16) {
                CircularProgressView(
                    percentage: data.sleepScore,
                    label: "quality",
                    color: .purple,
                    targetRange: nil
                )
                .padding(.top, 12)
                
                HStack(alignment: .top, spacing: 10) {
                    MetricRowView(
                        title: "In Bed",
                        value: formatDuration(minutes: data.timeInBedMinutes.value),
                        isHigher: data.timeInBedMinutes.status == .higherThanNormal
                    )
                    
                    MetricRowView(
                        title: "Asleep",
                        value: formatDuration(minutes: data.timeAsleepMinutes.value),
                        isHigher: data.timeAsleepMinutes.status == .higherThanNormal
                    )
                }
                .frame(height: 33)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(21)
    }
}

// Widget configuration for strain metrics
struct StrainWidget: Widget {
    let kind: String = "StrainWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StrainWidgetView(data: entry.metricData)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("Strain")
        .description("View your strain metrics.")
        .supportedFamilies([.systemSmall])
    }
}

// Widget configuration for recovery metrics
struct RecoveryWidget: Widget {
    let kind: String = "RecoveryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RecoveryWidgetView(data: entry.metricData)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("Recovery")
        .description("View your recovery metrics.")
        .supportedFamilies([.systemSmall])
    }
}

// Widget configuration for sleep metrics
struct SleepWidget: Widget {
    let kind: String = "SleepWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SleepWidgetView(data: entry.metricData)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("Sleep")
        .description("View your sleep metrics.")
        .supportedFamilies([.systemSmall])
    }
}

// Preview providers for each widget type
#Preview(as: .systemSmall) {
    StrainWidget()
} timeline: {
    HealthEntry(date: .now, metricData: MetricDataService().getMetricData())
}

#Preview(as: .systemSmall) {
    RecoveryWidget()
} timeline: {
    HealthEntry(date: .now, metricData: MetricDataService().getMetricData())
}

#Preview(as: .systemSmall) {
    SleepWidget()
} timeline: {
    HealthEntry(date: .now, metricData: MetricDataService().getMetricData())
}
