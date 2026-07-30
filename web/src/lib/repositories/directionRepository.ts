import { directions } from "@data/directions";
import type {Direction} from "@/models/direction";

export async function getDirections(): Promise<Direction[]> {

    return directions;

}