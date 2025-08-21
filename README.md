# Appliance Repair and Home Service Networks

A comprehensive blockchain-based system for managing appliance repair and home service operations using Clarity smart contracts.

## System Overview

This system provides a decentralized platform for managing the entire lifecycle of appliance repair and home services, from technician certification to customer feedback and warranty management.

## Core Features

### 1. Technician Management (`technician-registry.clar`)
- Technician registration and certification tracking
- Specialized equipment training records
- Skill verification and rating system
- Availability and scheduling management

### 2. Service Management (`service-manager.clar`)
- Service call creation and scheduling
- Service type definitions and pricing
- Status tracking throughout service lifecycle
- Integration with technician availability

### 3. Inventory Management (`inventory-tracker.clar`)
- Parts inventory tracking and management
- Supplier coordination and ordering
- Stock level monitoring and alerts
- Cost tracking and pricing updates

### 4. Customer System (`customer-portal.clar`)
- Customer registration and profile management
- Service request submission and tracking
- Communication with technicians
- Feedback and rating system

### 5. Warranty & Recalls (`warranty-system.clar`)
- Warranty registration and tracking
- Manufacturer recall notifications
- Warranty claim processing
- Service history integration

## Smart Contract Architecture

### Data Types
- **Technicians**: Certified service providers with skills and ratings
- **Services**: Individual service calls with scheduling and status
- **Inventory**: Parts and equipment with stock levels and pricing
- **Customers**: Service requesters with history and preferences
- **Warranties**: Product warranties with terms and claim history

### Key Functions
- Registration and certification management
- Service scheduling and coordination
- Inventory tracking and ordering
- Customer communication and feedback
- Warranty and recall management

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm for testing
- Basic understanding of Clarity smart contracts

### Installation
\`\`\`bash
npm install
clarinet check
clarinet test
\`\`\`

### Testing
\`\`\`bash
npm test
\`\`\`

## Contract Deployment

Deploy contracts in the following order:
1. `technician-registry.clar`
2. `inventory-tracker.clar`
3. `customer-portal.clar`
4. `service-manager.clar`
5. `warranty-system.clar`

## Usage Examples

### Register a Technician
```clarity
(contract-call? .technician-registry register-technician 
  "John Smith" 
  "HVAC,Electrical" 
  "Certified HVAC Technician")
