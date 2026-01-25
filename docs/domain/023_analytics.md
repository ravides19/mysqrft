# Analytics - Product Requirements

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Analytics |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | January 2026 |
| **Platform** | MySqrft |

---

## Overview

The Analytics domain is the measurement and decision support layer of the MySqrft platform, responsible for collecting, processing, and presenting actionable insights across all business operations. This domain transforms raw event data from every platform interaction into meaningful metrics, visualizations, and alerts that drive strategic and operational decisions.

As the intelligence backbone of the platform, Analytics provides comprehensive visibility into the entire user journey from initial property search through lead generation, site visits, deal closure, and revenue realization. It enables data-driven decision making by surfacing unit economics, cohort behavior patterns, and performance metrics at every level of the organization from individual Relationship Managers to city-level operations and executive leadership.

The Analytics domain operates as a consumer of events from all other MySqrft domains, aggregating and correlating data to provide holistic views of platform health, user behavior, and business performance. It balances the need for real-time operational dashboards with deep analytical capabilities for strategic planning, while maintaining robust anomaly detection to proactively identify issues, opportunities, and potential fraud before they impact the business.

## Goals & Objectives

- Provide end-to-end funnel visibility from search through revenue realization to identify conversion bottlenecks and optimization opportunities
- Enable cohort analysis across multiple dimensions (city, locality, channel, plan) to understand user behavior patterns and segment performance
- Track and report unit economics (CAC, ARPU, churn, attach rates) to ensure sustainable business growth and profitability
- Deliver real-time performance metrics for Relationship Managers and operational teams to drive accountability and coaching opportunities
- Detect and alert on anomalies, fraud patterns, and abuse signals to protect platform integrity and user trust
- Support custom reporting and dashboard creation to meet diverse stakeholder needs across product, operations, finance, and executive teams
- Maintain data quality and consistency across all metrics to ensure trustworthy decision-making

## Key Features

- **Funnel Analysis Engine**: Comprehensive tracking and visualization of the complete user journey from search impressions through lead creation, visit scheduling, deal closure, and revenue collection, with conversion rate calculations and drop-off analysis at each stage.

- **Cohort Analysis Platform**: Flexible cohort definition and analysis capabilities supporting segmentation by acquisition date, city, locality, marketing channel, subscription plan, user type, and custom attributes with retention and behavior tracking over time.

- **Unit Economics Dashboard**: Real-time calculation and reporting of key business metrics including Customer Acquisition Cost (CAC), Average Revenue Per User (ARPU), churn rates, plan attach rates, lifetime value (LTV), and LTV/CAC ratios with trending and forecasting.

- **RM Performance Analytics**: Individual and team-level performance tracking for Relationship Managers including lead response times, conversion rates, visit completion rates, deal closure rates, customer satisfaction scores, and revenue attribution.

- **Fraud and Abuse Detection**: Machine learning and rule-based systems for identifying suspicious patterns including fake listings, spam leads, fraudulent transactions, and platform manipulation with automated alerting and case creation.

- **Anomaly Detection and Alerting**: Statistical and ML-based monitoring of all key metrics with configurable thresholds, automatic alert generation, and escalation workflows for both positive anomalies (opportunities) and negative anomalies (issues).

- **Custom Reporting and Dashboards**: Self-service report builder and dashboard creation tools allowing stakeholders to create, save, schedule, and share custom views of platform data without engineering support.

## User Stories

1. **As a product manager**, I want to view conversion rates at each funnel stage so that I can identify where users are dropping off and prioritize improvements to increase overall conversion.

2. **As a city operations head**, I want to see cohort performance by locality so that I can understand which neighborhoods have the best unit economics and optimize marketing spend accordingly.

3. **As a finance analyst**, I want to track CAC, ARPU, and LTV metrics over time so that I can report on business health and forecast future revenue and profitability.

4. **As an RM team lead**, I want to view my team's performance metrics including lead response time and conversion rates so that I can identify coaching opportunities and recognize top performers.

5. **As a trust and safety analyst**, I want to receive alerts when fraud patterns are detected so that I can investigate and take action before fraudulent activity impacts users or revenue.

6. **As a marketing manager**, I want to analyze user cohorts by acquisition channel so that I can measure campaign effectiveness and optimize marketing budget allocation.

7. **As an executive**, I want a dashboard showing key business KPIs updated in real-time so that I can monitor overall platform health and make informed strategic decisions.

8. **As a data analyst**, I want to create custom reports combining data from multiple domains so that I can answer ad-hoc business questions without waiting for engineering support.

9. **As an operations manager**, I want to receive alerts when key metrics deviate significantly from expected ranges so that I can quickly investigate and respond to potential issues.

10. **As a quality assurance lead**, I want to track RM quality scores based on customer feedback and call recordings so that I can ensure service standards are maintained.

## Acceptance Criteria

1. **Funnel Tracking**
   - System captures and associates events across the complete funnel (search, view, lead, visit, close, revenue) with less than 0.1% data loss
   - Funnel reports display conversion rates between each stage with daily, weekly, and monthly granularity
   - Funnel data is available within 15 minutes of event occurrence for operational dashboards
   - Historical funnel data supports analysis going back at least 24 months
   - Funnel can be filtered by any combination of city, locality, property type, user type, and time period

2. **Cohort Analysis**
   - Cohorts can be defined by acquisition date, city, locality, channel, plan, and custom user attributes
   - Retention curves display user engagement over time periods from daily to yearly
   - Cohort comparison views show up to 12 cohorts simultaneously
   - Cohort metrics include retention, revenue, conversion, and custom event tracking
   - Cohort data is recalculated daily and available by 6 AM IST

3. **Unit Economics**
   - CAC is calculated with full attribution across all marketing channels with 48-hour data latency
   - ARPU is calculated at user, cohort, city, and platform levels with daily granularity
   - Churn rate is calculated using industry-standard definitions with monthly and annual views
   - LTV projections use validated statistical models with confidence intervals
   - All unit economics metrics support drill-down to contributing factors

4. **RM Performance Metrics**
   - Lead response time is measured from lead creation to first RM contact with accuracy within 1 minute
   - Conversion rates are tracked at lead-to-visit, visit-to-close, and end-to-end levels
   - Performance dashboards update within 5 minutes of underlying events
   - Individual RM, team, city, and platform-level aggregations are available
   - Quality scores incorporate customer feedback, call monitoring, and outcome metrics

5. **Anomaly Detection**
   - System detects deviations greater than 2 standard deviations from rolling baselines
   - Alerts are generated within 15 minutes of anomaly detection
   - False positive rate for anomaly alerts is below 10%
   - Alerts include context, severity classification, and suggested investigation steps
   - Alert history and resolution tracking is maintained for audit purposes

## Functional Requirements

### FR1: Event Collection and Processing
- System SHALL ingest events from all MySqrft domains via event bus subscription
- System SHALL validate event schema and data quality before processing
- System SHALL enrich events with dimensional data (user attributes, property attributes, location data)
- System SHALL deduplicate events based on event ID and timestamp
- System SHALL support event replay for historical reprocessing and backfill scenarios
- System SHALL maintain event processing latency under 5 minutes for 99% of events

### FR2: Funnel Analysis
- System SHALL define and maintain configurable funnel definitions with ordered stages
- System SHALL track user progression through funnel stages with accurate timestamping
- System SHALL calculate conversion rates between consecutive and non-consecutive stages
- System SHALL identify and quantify drop-off at each funnel stage
- System SHALL support funnel segmentation by any available dimension
- System SHALL generate funnel reports with time-series trending and comparison views

### FR3: Cohort Analysis
- System SHALL support cohort definition by acquisition date, city, locality, channel, plan, and custom attributes
- System SHALL calculate cohort retention using configurable engagement definitions
- System SHALL track cohort behavior metrics over configurable time windows
- System SHALL support cohort comparison across up to 20 cohorts simultaneously
- System SHALL export cohort data in CSV and JSON formats for external analysis
- System SHALL recalculate cohort metrics on a daily batch schedule

### FR4: Unit Economics Calculation
- System SHALL calculate Customer Acquisition Cost using attributed marketing spend and new user counts
- System SHALL calculate Average Revenue Per User at daily, monthly, and lifetime intervals
- System SHALL calculate churn rate using subscription cancellation and inactivity signals
- System SHALL calculate attach rates for add-on services and plan upgrades
- System SHALL calculate Lifetime Value using historical revenue and predictive models
- System SHALL provide trending and forecasting for all unit economics metrics

### FR5: RM Performance Tracking
- System SHALL track lead assignment timestamps and first contact timestamps per RM
- System SHALL calculate lead response time with configurable business hours rules
- System SHALL track conversion outcomes attributed to specific RMs
- System SHALL calculate RM quality scores incorporating multiple quality signals
- System SHALL aggregate RM metrics at team, city, and platform levels
- System SHALL support RM performance comparison and ranking views

### FR6: Fraud and Abuse Analytics
- System SHALL apply rule-based fraud detection logic to incoming events
- System SHALL apply machine learning models for fraud pattern recognition
- System SHALL score transactions and users for fraud probability
- System SHALL generate fraud alerts when scores exceed configurable thresholds
- System SHALL track fraud investigation outcomes for model feedback
- System SHALL maintain fraud pattern libraries with versioning and effectiveness tracking

### FR7: Anomaly Detection
- System SHALL establish rolling baselines for all tracked metrics using statistical methods
- System SHALL detect significant deviations using configurable sensitivity thresholds
- System SHALL classify anomalies by severity based on magnitude and business impact
- System SHALL generate alerts for detected anomalies with contextual information
- System SHALL support anomaly acknowledgment, investigation, and resolution workflows
- System SHALL learn from false positive feedback to improve detection accuracy

### FR8: Custom Reporting
- System SHALL provide a visual report builder interface for creating custom reports
- System SHALL support report creation combining metrics from multiple domains
- System SHALL support filtering, grouping, aggregation, and calculated fields in reports
- System SHALL support report scheduling with configurable frequency and recipients
- System SHALL support report export in PDF, Excel, and CSV formats
- System SHALL maintain report version history and access audit logs

### FR9: Dashboard Management
- System SHALL provide a dashboard builder with drag-and-drop widget placement
- System SHALL support multiple visualization types (charts, tables, KPIs, maps)
- System SHALL support dashboard parameter controls for interactive filtering
- System SHALL support dashboard sharing with role-based access control
- System SHALL support dashboard refresh intervals from real-time to daily
- System SHALL support dashboard embedding in external applications via secure iframe

### FR10: Data Quality and Governance
- System SHALL validate data completeness and accuracy using automated quality checks
- System SHALL maintain metric definitions with business logic documentation
- System SHALL track data lineage from source events through to computed metrics
- System SHALL generate data quality reports and alerts for quality degradation
- System SHALL support metric versioning with backward compatibility for historical comparisons
- System SHALL maintain an audit trail of all metric definition changes

## Non-Functional Requirements

### NFR1: Performance
- Dashboard load time: <3 seconds for standard dashboards (95th percentile)
- Report generation time: <30 seconds for reports up to 1 million rows
- Event ingestion latency: <5 minutes from event occurrence to availability in dashboards
- Query response time: <10 seconds for complex analytical queries (95th percentile)
- Real-time metrics refresh: Every 5 minutes for operational dashboards
- Batch processing completion: By 6 AM IST for daily metrics recalculation

### NFR2: Scalability
- System SHALL process 100 million events per day with headroom for 5x growth
- System SHALL support 1,000 concurrent dashboard users without performance degradation
- System SHALL support 10,000 saved reports and 500 custom dashboards
- System SHALL scale data storage to accommodate 3 years of granular event data
- System SHALL support horizontal scaling of query processing for peak loads
- System SHALL partition data by time and dimension for query optimization

### NFR3: Reliability
- System SHALL maintain 99.9% availability for dashboard and reporting services
- System SHALL implement data replication for disaster recovery with RPO <1 hour
- System SHALL queue events during downstream system outages with automatic replay
- System SHALL provide graceful degradation showing cached data during partial outages
- System SHALL implement automated failover for critical data processing pipelines
- System SHALL maintain separate availability for real-time and batch processing systems

### NFR4: Security
- System SHALL enforce role-based access control for all dashboards and reports
- System SHALL mask or aggregate sensitive data based on user permissions
- System SHALL encrypt all data in transit and at rest
- System SHALL maintain audit logs of all data access and report generation
- System SHALL support data access restrictions by city, team, or other organizational scopes
- System SHALL comply with data retention and deletion policies for user data

### NFR5: Data Quality
- System SHALL maintain data accuracy of 99.9% for all computed metrics
- System SHALL track and report data freshness for all metrics and dashboards
- System SHALL implement automated data quality monitoring with alerting
- System SHALL document calculation methodology for all metrics
- System SHALL provide data lineage visibility for audit and troubleshooting
- System SHALL support data reconciliation between Analytics and source systems

## Integration Points

- **Auth Domain**: Consumes authentication events for user session analytics, login pattern analysis, and security monitoring

- **UserManagement Domain**: Consumes user profile events for cohort definition, demographic analysis, and user attribute enrichment

- **Inventory Domain**: Consumes listing events for supply analytics, listing quality metrics, and inventory health monitoring

- **Search Domain**: Consumes search events for search funnel analysis, query pattern analysis, and recommendation effectiveness

- **Leads Domain**: Consumes lead events for lead funnel analysis, lead quality scoring, and conversion attribution

- **CRM Domain**: Consumes interaction events for RM performance analytics, customer journey analysis, and follow-up effectiveness

- **Sales Domain**: Consumes sales events for revenue analytics, plan performance analysis, and sales pipeline metrics

- **Billing Domain**: Consumes payment events for revenue analytics, unit economics calculation, and financial reporting

- **Marketing Domain**: Consumes campaign events for attribution analysis, campaign performance, and marketing ROI calculation

- **Scheduling Domain**: Consumes visit events for visit funnel analysis, scheduling efficiency, and visit outcome tracking

- **Communications Domain**: Consumes notification events for channel effectiveness analysis and communication optimization

- **Support Domain**: Consumes ticket events for support analytics, resolution time tracking, and customer satisfaction analysis

- **TrustSafety Domain**: Publishes fraud signals and anomaly alerts; consumes moderation events for abuse analytics

- **Ops Domain**: Publishes operational dashboards and reports; consumes configuration changes for impact analysis

- **Data Warehouse**: Exports processed metrics and aggregates for long-term storage and advanced analytics

- **Business Intelligence Tools**: Exposes APIs and data connections for Tableau, Looker, and other BI tool integration

## Dependencies

- Apache Kafka or equivalent event streaming platform for real-time event ingestion
- Apache Spark or equivalent distributed processing framework for batch analytics
- ClickHouse, Apache Druid, or equivalent OLAP database for analytical queries
- PostgreSQL or equivalent relational database for metric definitions and report metadata
- Redis or equivalent cache for dashboard query caching and session management
- Time-series database (InfluxDB, TimescaleDB) for metrics storage and anomaly detection
- Machine learning platform (MLflow, SageMaker) for fraud detection and predictive models
- Tigris Object Storage (S3-compatible) for raw event archival and report file storage
- Visualization libraries (D3.js, Apache ECharts) for dashboard rendering
- Scheduling system (Apache Airflow) for batch job orchestration

## Success Metrics

- **Dashboard Adoption Rate**: Percentage of target users actively using dashboards weekly (target: >80%)
- **Report Generation Volume**: Number of reports generated per week indicating platform utility (target: >500 reports/week)
- **Data Freshness SLA**: Percentage of metrics meeting freshness requirements (target: >99%)
- **Alert Accuracy**: Percentage of anomaly alerts that result in actionable investigations (target: >90%)
- **Query Performance SLA**: Percentage of queries completing within SLA (target: >95% under 10 seconds)
- **Fraud Detection Rate**: Percentage of confirmed fraud cases detected by analytics (target: >85%)
- **False Positive Rate**: Percentage of fraud alerts that are false positives (target: <10%)
- **Data Quality Score**: Composite score of data completeness, accuracy, and consistency (target: >98%)
- **Self-Service Adoption**: Percentage of reports created by non-technical users (target: >50%)
- **Decision Impact**: Number of documented business decisions influenced by analytics insights (target: >20/month)
- **Cost Per Query**: Average infrastructure cost per analytical query (target: <$0.001)
- **User Satisfaction**: NPS score from analytics platform users (target: >40)
