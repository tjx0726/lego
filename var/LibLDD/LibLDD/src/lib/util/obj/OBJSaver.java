package lib.util.obj;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;

import lib.ldd.data.GeometryWithMaterial;
import lib.ldd.data.Material;
import lib.ldd.data.Mesh;
import lib.ldd.data.VBOContents;

public class OBJSaver {
    public static void save(Mesh mesh, File directory, String fileName) throws IOException {
        if (!directory.isDirectory() || !directory.exists()) {
            throw new IOException("OBJ files can only be saved to a directory.");
        }
        ArrayList<Material> usedMaterials = new ArrayList<Material>();
        int indexOffset = 0;

        File objFile = new File(directory, fileName + ".obj");
        objFile.createNewFile();
        File mtlFile = new File(directory, fileName + ".mtl");
        mtlFile.createNewFile();

        PrintWriter objWriter = new PrintWriter(objFile);
        PrintWriter mtlWriter = new PrintWriter(mtlFile);

        objWriter.println("mtllib " + mtlFile.getName());

        for (GeometryWithMaterial group : mesh.contents) {
            usedMaterials.add(group.material);
            for (VBOContents geometryGroup : group.geometry) {
                writeGroup(geometryGroup, "" + group.material.id, objWriter, Integer.parseInt(fileName), indexOffset);
                indexOffset += (geometryGroup.vertices.length / 3);
            }
        }
        writeMaterials(usedMaterials, mtlWriter);

        objWriter.close();
        mtlWriter.close();
    }

    private static String num2str(float a) {
        return "" + a; //"" + (Math.round(a * 1e+6) / 1.0e+6);
    }

    public static void writeGroup(VBOContents combo, String materialName, PrintWriter writer, int brickid, int indexOffset) {
        //DecimalFormat df = new DecimalFormat();
        //df.setMaximumFractionDigits(8);

//        writer.println("mtllib materials.mtl");

        writer.println("o brick_" + brickid);
//        writer.println("usemtl " + materialName);
//        writer.println("g " + indexOffset);
        writer.println("g 0");

        for (int i = 0; i < combo.vertices.length; i += 3) {
            writer.println("v " + num2str(combo.vertices[i]) + " " + num2str(combo.vertices[i + 1]) + " " + num2str(combo.vertices[i + 2]) + " ");
        }

        writer.println();

        for (int i = 0; i < combo.normals.length; i += 3) {
            writer.println("vn " + num2str(combo.normals[i]) + " " + num2str(combo.normals[i + 1]) + " " + num2str(combo.normals[i + 2]) + " ");
        }

        writer.println();

        for (int i = 0; i < combo.indices.length; i += 3) {
            int index1 = combo.indices[i] + 1 + indexOffset;
            int index2 = combo.indices[i + 1] + 1 + indexOffset;
            int index3 = combo.indices[i + 2] + 1 + indexOffset;
            writer.println("f " + index1 + "//" + index1 + " "
                    + index2 + "//" + index2 + " "
                    + index3 + "//" + index3);
        }
    }

    public static void writeMaterials(ArrayList<Material> usedMaterials, PrintWriter writer) {
        for (Material material : usedMaterials) {
            writer.println("newmtl " + material.id);
            writer.println();
            writer.println("Ka 0.000 0.000 0.000");
            writer.println("Kd " + (((float) material.red) / 255f) + " " + (((float) material.green) / 255f) + " " + (((float) material.blue) / 255f));
            writer.println("Ks 0.700 0.700 0.700");
            writer.println("Ns 50.000");
            writer.println("d " + (((float) material.alpha) / 255f));
            writer.println("Tr " + (((float) material.alpha) / 255f));
            writer.println();
        }
    }
}
