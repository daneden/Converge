//
//  UnitTypes.swift
//  Converge
//
//  Created by Daniel Eden on 12/24/16.
//  Copyright © 2016 Daniel Eden. All rights reserved.
//

import Foundation

typealias DEUnit = [String:Unit]

let Units: Array<[String:Array<DEUnit>]> = [
    ["Length": Length],
    ["Volume": Volume],
    ["Temperature": Temperature],
    ["Speed": Speed],
    ["Mass": Mass],
    ["Area": Area],
]

enum Types {
    case UnitLength
    case UnitVolume
    case UnitTemperature
    case UnitSpeed
    case UnitMass
    case UnitArea
}

let Length: Array<DEUnit> = [
    ["Kilometers": UnitLength.kilometers],
    ["Meters": UnitLength.meters],
    ["Centimeters": UnitLength.centimeters],
    ["Millimeters": UnitLength.millimeters],
    ["Micrometers": UnitLength.micrometers],
    ["Nanometers": UnitLength.nanometers],
    ["Miles": UnitLength.miles],
    ["Yards": UnitLength.yards],
    ["Feet": UnitLength.feet],
    ["Inches": UnitLength.inches],
    ["Nautical Miles": UnitLength.nauticalMiles],
]

let Volume: Array<DEUnit> = [
    ["Gallons": UnitVolume.gallons],
    ["Quarts": UnitVolume.quarts],
    ["Pints": UnitVolume.pints],
    ["Cups": UnitVolume.cups],
    ["Fluid Ounces": UnitVolume.fluidOunces],
    ["Tablespoons": UnitVolume.tablespoons],
    ["Teaspoons": UnitVolume.teaspoons],
    ["Cubic Meters": UnitVolume.cubicMeters],
    ["Liters": UnitVolume.liters],
    ["Millileters": UnitVolume.milliliters],
    ["Imperial Gallons": UnitVolume.imperialGallons],
    ["Imperial Quarts": UnitVolume.imperialQuarts],
    ["Imperial Pints": UnitVolume.imperialPints],
    ["Imperial Fluid Ounces": UnitVolume.imperialFluidOunces],
    ["Imperial Tablespoons": UnitVolume.imperialTablespoons],
    ["Imperial Teaspoons": UnitVolume.imperialTeaspoons],
    ["Cubic Feet": UnitVolume.cubicFeet],
    ["Cubic Inches": UnitVolume.cubicInches],
]

let Temperature: Array<DEUnit> = [
    ["Celcius": UnitTemperature.celsius],
    ["Fahrenheit": UnitTemperature.fahrenheit],
    ["Kelvin": UnitTemperature.kelvin],
]

let Speed: Array<DEUnit> = [
    ["Miles per hour": UnitSpeed.milesPerHour],
    ["Kilometers per hour": UnitSpeed.kilometersPerHour],
    ["Knots": UnitSpeed.knots],
]

let Mass: Array<DEUnit> = [
    ["Metric Tons": UnitMass.metricTons],
    ["Kilograms": UnitMass.kilograms],
    ["Grams": UnitMass.grams],
    ["Milligrams": UnitMass.milligrams],
    ["Micrograms": UnitMass.micrograms],
    ["Stones": UnitMass.stones],
    ["Pounds": UnitMass.pounds],
    ["Ounces": UnitMass.ounces],
]

let Area: Array<DEUnit> = [
    ["Square Kilometers": UnitArea.squareKilometers],
    ["Square Meters": UnitArea.squareMeters],
    ["Square Miles": UnitArea.squareMiles],
    ["Square Yards": UnitArea.squareYards],
    ["Square Inches": UnitArea.squareInches],
    ["Hectares": UnitArea.hectares],
    ["Acres": UnitArea.acres],
]
